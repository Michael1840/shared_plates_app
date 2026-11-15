import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/ids.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';
import 'package:shared_plates_app/features/create/domain/tag_guesser.dart';

enum SaveStatus { clean, pending, saving, saved, failed }

abstract final class EditorMessages {
  static String problem(DraftProblem p) => switch (p) {
    DraftProblem.name => 'Give it a name first.',
    DraftProblem.ingredients => 'Add at least one ingredient.',
    DraftProblem.steps => 'Add at least one step.',
  };
}

class EditorState extends Equatable {
  EditorState({
    required this.draft,
    FoodLibrary? library,
    this.tags = const [],
    this.loading = true,
    this.save = SaveStatus.clean,
    this.publish = const DelayedResult.idle(),
    this.showProblems = false,
    this.focusStepId,
    this.focusTick = 0,
  }) : library = library ?? FoodLibrary();

  final RecipeDraft draft;
  final FoodLibrary library;
  final List<Tag> tags;
  final bool loading;
  final SaveStatus save;
  final DelayedResult<String> publish;
  final bool showProblems;
  final String? focusStepId;
  final int focusTick;

  late final NutritionTotals nutrition = NutritionTotals.of(draft, library);

  late final Set<int> guesses = TagGuesser.guess(
    draft: draft,
    library: library,
    tags: tags,
  );

  Tag? tagById(int id) {
    for (final t in tags) {
      if (t.id == id) return t;
    }
    return null;
  }

  FoodMatch? suggestionFor(DraftIngredient i) =>
      i.foodId != null || i.keptAsIs ? null : library.suggest(i.displayName);

  EditorState copyWith({
    RecipeDraft? draft,
    FoodLibrary? library,
    List<Tag>? tags,
    bool? loading,
    SaveStatus? save,
    DelayedResult<String>? publish,
    bool? showProblems,
    String? focusStepId,
    int? focusTick,
  }) => EditorState(
    draft: draft ?? this.draft,
    library: library ?? this.library,
    tags: tags ?? this.tags,
    loading: loading ?? this.loading,
    save: save ?? this.save,
    publish: publish ?? this.publish,
    showProblems: showProblems ?? this.showProblems,
    focusStepId: focusStepId ?? this.focusStepId,
    focusTick: focusTick ?? this.focusTick,
  );

  @override
  List<Object?> get props => [
    draft,
    library,
    tags,
    loading,
    save,
    publish,
    showProblems,
    focusStepId,
    focusTick,
  ];
}

class RecipeEditorCubit extends Cubit<EditorState> {
  RecipeEditorCubit({
    required this._repository,
    required this._photos,
    required this._userId,
    required String recipeId,
    RecipeVisibility visibility = RecipeVisibility.friends,
    this._debounce = const Duration(milliseconds: 700),
  }) : super(
         EditorState(
           draft: RecipeDraft(
             id: recipeId,
             visibility: visibility,
             createdAt: DateTime.now().toUtc(),
           ),
         ),
       );

  final CreateRepository _repository;
  final PhotoStore _photos;
  final String _userId;
  final Duration _debounce;
  Timer? _timer;
  bool _stored = false;
  Future<void>? _saving;

  Future<void> start() async {
    final library = await _repository.library();
    final tags = await _repository.tags();
    final stored = await _repository.load(state.draft.id);
    if (isClosed) return;
    _stored = stored != null;
    emit(
      state.copyWith(
        draft: stored,
        library: library,
        tags: tags,
        loading: false,
        save: stored == null ? SaveStatus.clean : SaveStatus.saved,
      ),
    );
  }

  void _change(RecipeDraft draft) {
    emit(state.copyWith(draft: draft, save: SaveStatus.pending));
    _timer?.cancel();
    _timer = Timer(_debounce, () => unawaited(flush()));
  }

  Future<void> flush({bool push = false}) async {
    _timer?.cancel();
    await _saving;
    if (isClosed && !push) return;
    final draft = state.draft;
    if (!_stored && draft.isBlank) return;
    if (state.save == SaveStatus.saved && !push) return;
    final saving = _persist(draft, push: push);
    _saving = saving;
    await saving;
  }

  Future<void> _persist(RecipeDraft draft, {required bool push}) async {
    if (!isClosed) emit(state.copyWith(save: SaveStatus.saving));
    final result = await _repository.save(
      _userId,
      draft,
      state.library,
      push: push,
    );
    _stored = true;
    if (isClosed) return;
    final latest = state.draft == draft;
    emit(
      state.copyWith(
        save: switch (result) {
          Ok<void>() => latest ? SaveStatus.saved : SaveStatus.pending,
          _ => SaveStatus.failed,
        },
      ),
    );
    if (!latest) {
      _timer?.cancel();
      _timer = Timer(_debounce, () => unawaited(flush()));
    }
  }

  void setTitle(String title) => _change(state.draft.copyWith(title: title));

  void changeServings(int delta) {
    final next = (state.draft.servings + delta).clamp(
      RecipeDraft.minServings,
      RecipeDraft.maxServings,
    );
    if (next != state.draft.servings) {
      _change(state.draft.copyWith(servings: next));
    }
  }

  void setMinutes(String text) {
    final minutes = int.tryParse(text.trim());
    _change(
      minutes == null || minutes < 1
          ? state.draft.copyWith(clearMinutes: true)
          : state.draft.copyWith(
              totalMinutes: minutes.clamp(1, RecipeDraft.maxMinutes),
            ),
    );
  }

  void setVisibility(RecipeVisibility visibility) =>
      _change(state.draft.copyWith(visibility: visibility));

  void setCoverStyle(CoverStyle style) =>
      _change(state.draft.copyWith(coverStyle: style));

  void toggleTag(int id) {
    final tags = {...state.draft.tagIds};
    if (!tags.remove(id)) tags.add(id);
    _change(state.draft.copyWith(tagIds: tags));
  }

  Future<void> pickPhoto(PhotoSource source) async {
    final path = await _photos.pick(source, recipeId: state.draft.id);
    if (path == null || isClosed) return;
    _change(
      state.draft.copyWith(clearPhoto: true).copyWith(localCoverPath: path),
    );
  }

  void removePhoto() => _change(state.draft.copyWith(clearPhoto: true));

  void addIngredients(String text) {
    final lines = RecipeParser.classify('Ingredients\n$text');
    final parsed = RecipeParser.assemble([
      for (final l in lines)
        if (l.kind == LineKind.heading ||
            l.kind == LineKind.section ||
            l.kind == LineKind.ingredient)
          l
        else
          l.as(LineKind.ingredient),
    ]);
    if (parsed.ingredients.isEmpty) return;
    _change(
      state.draft.copyWith(
        ingredients: [
          ...state.draft.ingredients,
          for (final p in parsed.ingredients)
            DraftIngredient.fromParsed(Ids.next(), p, library: state.library),
        ],
      ),
    );
  }

  void updateIngredient(String id, String text) {
    final line = text.trim();
    if (line.isEmpty) {
      removeIngredient(id);
      return;
    }
    _change(
      state.draft.copyWith(
        ingredients: [
          for (final i in state.draft.ingredients)
            if (i.id != id)
              i
            else if (i.rawText == line)
              i
            else
              DraftIngredient.fromLine(
                id,
                line,
                library: state.library,
                section: i.section,
                costCents: i.costCents,
              ),
        ],
      ),
    );
  }

  void removeIngredient(String id) => _change(
    state.draft.copyWith(
      ingredients: [
        for (final i in state.draft.ingredients)
          if (i.id != id) i,
      ],
    ),
  );

  void reorderIngredient(int from, int to) {
    final list = [...state.draft.ingredients];
    if (from < 0 || from >= list.length || to == from) return;
    final item = list.removeAt(from);
    list.insert(to.clamp(0, list.length), item);
    _change(state.draft.copyWith(ingredients: list));
  }

  void setCost(String id, String rands) {
    final value = double.tryParse(rands.replaceAll(',', '.').trim());
    _change(
      state.draft.copyWith(
        ingredients: [
          for (final i in state.draft.ingredients)
            if (i.id != id)
              i
            else if (value == null || value < 0)
              i.copyWith(clearCost: true)
            else
              i.copyWith(costCents: (value * 100).round()),
        ],
      ),
    );
  }

  void useFood(String id, String foodId) =>
      _updateIngredient(id, (i) => i.copyWith(foodId: foodId, keptAsIs: false));

  void keepAsIs(String id) =>
      _updateIngredient(id, (i) => i.copyWith(keptAsIs: true));

  void _updateIngredient(
    String id,
    DraftIngredient Function(DraftIngredient) update,
  ) => _change(
    state.draft.copyWith(
      ingredients: [
        for (final i in state.draft.ingredients)
          if (i.id == id) update(i) else i,
      ],
    ),
  );

  String addStep({String? after}) {
    final step = DraftStep(id: Ids.next());
    final steps = [...state.draft.steps];
    final at = after == null
        ? steps.length
        : steps.indexWhere((s) => s.id == after) + 1;
    steps.insert(at <= 0 ? steps.length : at, step);
    emit(
      state.copyWith(
        draft: state.draft.copyWith(steps: steps),
        focusStepId: step.id,
        focusTick: state.focusTick + 1,
      ),
    );
    return step.id;
  }

  void updateStep(String id, String body) => _change(
    state.draft.copyWith(
      steps: [
        for (final s in state.draft.steps)
          if (s.id == id) DraftStep(id: id, body: body) else s,
      ],
    ),
  );

  void removeStep(String id) => _change(
    state.draft.copyWith(
      steps: [
        for (final s in state.draft.steps)
          if (s.id != id) s,
      ],
    ),
  );

  void pasteMethod(String text) {
    final lines = RecipeParser.classify('Method\n$text');
    final parsed = RecipeParser.assemble([
      for (final l in lines)
        if (l.kind == LineKind.heading) l else l.as(LineKind.step),
    ]);
    if (parsed.steps.isEmpty) return;
    _change(
      state.draft.copyWith(
        steps: [
          ...state.draft.filledSteps,
          for (final s in parsed.steps) DraftStep(id: Ids.next(), body: s.body),
        ],
      ),
    );
  }

  Future<void> saveDraft() => flush(push: true);

  Future<String?> publish() async {
    final problems = state.draft.problems;
    if (problems.isNotEmpty) {
      emit(
        state.copyWith(
          showProblems: true,
          publish: DelayedResult.fromError(
            EditorMessages.problem(problems.first),
          ),
        ),
      );
      return null;
    }
    emit(state.copyWith(publish: const DelayedResult.inProgress()));
    _timer?.cancel();
    await _saving;
    final draft = state.draft.copyWith(
      status: RecipeStatus.published,
      publishedAt: state.draft.publishedAt ?? DateTime.now().toUtc(),
    );
    final result = await _repository.save(
      _userId,
      draft,
      state.library,
      push: true,
    );
    _stored = true;
    if (isClosed) return null;
    switch (result) {
      case Ok<void>():
        emit(
          state.copyWith(
            draft: draft,
            save: SaveStatus.saved,
            publish: DelayedResult.fromValue(draft.id),
          ),
        );
        return draft.id;
      case Error<void>(:final error):
        emit(
          state.copyWith(publish: DelayedResult.fromError(error.cleanError)),
        );
        return null;
      case CastError<void>(:final error):
        emit(
          state.copyWith(publish: DelayedResult.fromError(error.cleanError)),
        );
        return null;
    }
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _saving;
    final draft = state.draft;
    if (!state.loading &&
        !state.publish.isSuccessful &&
        (_stored || !draft.isBlank)) {
      await _repository.save(_userId, draft, state.library, push: true);
    }
    await super.close();
  }
}
