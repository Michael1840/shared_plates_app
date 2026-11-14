import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockProfileRepository profiles;

  setUpAll(() => registerFallbackValue(UnitSystem.metric));

  setUp(() {
    profiles = MockProfileRepository();
    when(() => profiles.watchTags()).thenAnswer((_) => const Stream.empty());
  });

  OnboardingCubit build({String? country}) => OnboardingCubit(
    profiles: profiles,
    userId: 'u1',
    countryCode: country,
    debounce: Duration.zero,
  );

  group('units', () {
    test('defaults to metric outside the US', () {
      expect(OnboardingCubit.unitsForCountry('ZA'), UnitSystem.metric);
      expect(OnboardingCubit.unitsForCountry(null), UnitSystem.metric);
      expect(OnboardingCubit.unitsForCountry('us'), UnitSystem.imperial);
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'a manual pick drops the region hint',
      build: build,
      act: (c) => c.unitsChanged(UnitSystem.imperial),
      expect: () => [
        const OnboardingState(
          units: UnitSystem.imperial,
          unitsFromRegion: false,
        ),
      ],
    );
  });

  group('username', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'rejects bad characters without asking the server',
      build: build,
      act: (c) => c.usernameChanged('Thandi Cooks'),
      expect: () => [
        const OnboardingState(
          username: 'thandi cooks',
          usernameCheck: UsernameCheck.invalid,
        ),
      ],
      verify: (_) => verifyNever(() => profiles.isUsernameAvailable(any())),
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'checks availability after a pause',
      setUp: () =>
          when(() => profiles.isUsernameAvailable('thandi.cooks'))
              .thenAnswer((_) async => const Result.ok(true)),
      build: build,
      act: (c) async {
        c.usernameChanged('thandi.cooks');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      expect: () => [
        const OnboardingState(
          username: 'thandi.cooks',
          usernameCheck: UsernameCheck.checking,
        ),
        const OnboardingState(
          username: 'thandi.cooks',
          usernameCheck: UsernameCheck.available,
        ),
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'reports taken names',
      setUp: () =>
          when(() => profiles.isUsernameAvailable('lerato'))
              .thenAnswer((_) async => const Result.ok(false)),
      build: build,
      act: (c) async {
        c.usernameChanged('lerato');
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      skip: 1,
      expect: () => [
        const OnboardingState(
          username: 'lerato',
          usernameCheck: UsernameCheck.taken,
        ),
      ],
    );
  });

  group('saving', () {
    setUp(() {
      when(
        () => profiles.saveBasics(
          uid: any(named: 'uid'),
          displayName: any(named: 'displayName'),
          units: any(named: 'units'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'keeps the old username when it was not changed',
      build: build,
      seed: () => const OnboardingState(
        displayName: ' Thandi ',
        username: 'thandi',
        originalUsername: 'thandi',
      ),
      act: (c) => c.saveYou(),
      verify: (_) => verify(
        () => profiles.saveBasics(
          uid: 'u1',
          displayName: 'Thandi',
          units: UnitSystem.metric,
        ),
      ).called(1),
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'sends a new username once it is available',
      build: build,
      seed: () => const OnboardingState(
        displayName: 'Thandi',
        username: 'thandi.cooks',
        originalUsername: 'thandi',
        usernameCheck: UsernameCheck.available,
      ),
      act: (c) => c.saveYou(),
      verify: (_) => verify(
        () => profiles.saveBasics(
          uid: 'u1',
          displayName: 'Thandi',
          units: UnitSystem.metric,
          username: 'thandi.cooks',
        ),
      ).called(1),
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'saves picked tastes and foods to avoid',
      setUp: () => when(
        () => profiles.saveTastes(
          uid: 'u1',
          tagIds: {3, 7},
          avoid: {AvoidOption.pork},
        ),
      ).thenAnswer((_) async => const Result.ok(null)),
      build: build,
      act: (c) async {
        c
          ..toggleTaste(3)
          ..toggleTaste(7)
          ..toggleTaste(9)
          ..toggleTaste(9)
          ..toggleAvoid(AvoidOption.pork);
        await c.saveTastes();
      },
      verify: (c) => expect(c.state.tasteIds, {3, 7}),
    );
  });

  group('friends', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'rolls back a request that could not be queued',
      setUp: () =>
          when(() => profiles.requestFriend('c1'))
              .thenAnswer((_) async => Result.error(Exception('nope'))),
      build: build,
      act: (c) => c.requestFriend('c1'),
      expect: () => [
        const OnboardingState(requested: {'c1'}),
        const OnboardingState(),
      ],
    );
  });

  test('loads tags as they sync in', () async {
    final tags = StreamController<List<Tag>>();
    when(() => profiles.watchTags()).thenAnswer((_) => tags.stream);
    when(() => profiles.localProfile('u1')).thenAnswer((_) async => null);
    final cubit = build();
    await cubit.load();
    final tag = Tag(
      id: 1,
      slug: 'braai',
      label: 'Braai',
      kind: TagKind.occasion,
      updatedAt: DateTime.utc(2026, 11),
    );
    tags.add([tag]);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.tags, [tag]);
    await tags.close();
    await cubit.close();
  });
}
