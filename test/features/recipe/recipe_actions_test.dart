import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_actions_repository.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';

import '../../helpers/fake_remote_store.dart';
import '../../helpers/mocks.dart';

class _FakeSession extends Fake implements SessionCubit {
  new(this._state);

  final SessionState _state;

  @override
  SessionState get state => _state;

  @override
  Stream<SessionState> get stream => const Stream.empty();
}

final _card = RecipeCard(
  id: 'r1',
  authorId: 'author',
  title: 'Cape Malay chicken curry',
  updatedAt: DateTime.utc(2026, 11, 13),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('RecipeActionsRepository', () {
    late AppDatabase db;
    late OutboxStore outbox;
    late FakeRemoteStore remote;
    late SyncService sync;
    late RecipeActionsRepositoryImpl repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      outbox = OutboxStore(db);
      remote = FakeRemoteStore(userId: 'u1');
      sync = SyncService(
        db: db,
        outbox: outbox,
        remote: remote,
        debounce: const Duration(days: 1),
      );
      repo = RecipeActionsRepositoryImpl(db: db, outbox: outbox, sync: sync);
    });

    tearDown(() async {
      await sync.dispose();
      await db.close();
    });

    test('saving caches the recipe and queues an idempotent insert', () async {
      await repo.setSaved('u1', _card, saved: true);

      expect(await repo.watchSavedIds('u1').first, {'r1'});
      final cached = await db.select(db.recipes).getSingle();
      expect(cached.title, _card.title);
      await sync.pushOutbox();
      await outbox.enqueue(
        OutboxOperation.insertIgnoringDuplicates('saves', {
          'user_id': 'u1',
          'recipe_id': 'r1',
        }, conflictColumns: 'user_id,recipe_id'),
      );
      await sync.pushOutbox();
      expect(remote.tables['saves'], hasLength(1));
    });

    test('save then unsave offline sends only the delete', () async {
      await repo.setSaved('u1', _card, saved: true);
      await repo.setSaved('u1', _card, saved: false);

      final queued = await outbox.due();
      expect(queued.single.kind, OutboxKind.delete);
      expect(await repo.watchSavedIds('u1').first, isEmpty);
    });

    test('likes toggle locally', () async {
      await repo.setLiked('u1', _card, liked: true);
      expect(await repo.watchLikedIds('u1').first, {'r1'});
      await repo.setLiked('u1', _card, liked: false);
      expect(await repo.watchLikedIds('u1').first, isEmpty);
    });
  });

  group('RecipeActionsCubit', () {
    late MockRecipeActionsRepository actions;
    late StreamController<Set<String>> saved;

    setUpAll(() => registerFallbackValue(_card));

    setUp(() {
      actions = MockRecipeActionsRepository();
      saved = StreamController<Set<String>>.broadcast();
      when(() => actions.watchSavedIds('u1')).thenAnswer((_) => saved.stream);
      when(() => actions.watchLikedIds('u1'))
          .thenAnswer((_) => const Stream.empty());
    });

    tearDown(() => saved.close());

    test('guests are asked to sign in', () async {
      final cubit = RecipeActionsCubit(
        actions: actions,
        session: _FakeSession(const SessionState(status: SessionStatus.guest)),
      );

      expect(await cubit.toggleSave(_card), ActionOutcome.needsAccount);
      verifyNever(
        () => actions.setSaved(any(), any(), saved: any(named: 'saved')),
      );
      await cubit.close();
    });

    test('saves optimistically', () async {
      when(() => actions.setSaved('u1', _card, saved: true))
          .thenAnswer((_) async => const Result.ok(true));
      final cubit = RecipeActionsCubit(
        actions: actions,
        session: _FakeSession(
          const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
        ),
      );

      final outcome = await cubit.toggleSave(_card);

      expect(outcome, ActionOutcome.done);
      expect(cubit.state.isSaved('r1'), isTrue);
      await cubit.close();
    });

    test('rolls back and reports when the save fails', () async {
      when(() => actions.setSaved('u1', _card, saved: true))
          .thenAnswer((_) async => Result.error(Exception('disk full')));
      final cubit = RecipeActionsCubit(
        actions: actions,
        session: _FakeSession(
          const SessionState(status: SessionStatus.signedIn, userId: 'u1'),
        ),
      );

      final outcome = await cubit.toggleSave(_card);

      expect(outcome, ActionOutcome.failed);
      expect(cubit.state.isSaved('r1'), isFalse);
      expect(cubit.state.error, 'disk full');
      expect(cubit.state.errorTick, 1);
      await cubit.close();
    });
  });
}
