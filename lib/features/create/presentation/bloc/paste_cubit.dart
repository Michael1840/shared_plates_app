import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/ids.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';

enum PasteStage { input, review }

abstract final class PasteMessages {
  static const empty = 'Paste a recipe first.';
  static const tooLong =
      "That's longer than a recipe. Paste up to 20,000 characters.";
  static const nothing =
      "I couldn't find ingredients or steps in that. Try pasting the whole "
      'recipe.';
}

class PasteState extends Equatable {
  const new({
    this.stage = PasteStage.input,
    this.text = '',
    this.lines = const [],
    this.labels = const {},
    this.decisions = const {},
    this.showAll = false,
    this.error,
    this.build = const DelayedResult.idle(),
  });

  static const maxLength = 20000;
  static const collapsedCount = 10;

  final PasteStage stage;
  final String text;
  final List<ParsedLine> lines;
  final Map<int, LineKind> labels;
  final Map<int, bool> decisions;
  final bool showAll;
  final String? error;
  final DelayedResult<String> build;

  LineKind kindOf(ParsedLine line) => labels[line.index] ?? line.kind;

  List<ParsedLine> get unsure => [
    for (final l in lines)
      if (l.unsure && !decisions.containsKey(l.index)) l,
  ];

  List<ParsedLine> get reviewed => [
    for (final l in lines)
      if (l.kind != LineKind.heading &&
          (!l.unsure || decisions[l.index] == true))
        l.as(kindOf(l)),
  ];

  List<ParsedLine> get visible =>
      showAll ? reviewed : reviewed.take(collapsedCount).toList();

  int get hiddenIngredients => reviewed
      .skip(collapsedCount)
      .where((l) => l.kind == LineKind.ingredient)
      .length;

  int get hiddenCount =>
      showAll ? 0 : math.max(0, reviewed.length - collapsedCount);

  int get lineCount => lines.length;

  ParsedRecipe get recipe => RecipeParser.assemble([
    for (final l in lines)
      if (!l.unsure || decisions[l.index] == true) l.as(kindOf(l)),
  ]);

  PasteState copyWith({
    PasteStage? stage,
    String? text,
    List<ParsedLine>? lines,
    Map<int, LineKind>? labels,
    Map<int, bool>? decisions,
    bool? showAll,
    String? error,
    bool clearError = false,
    DelayedResult<String>? build,
  }) => PasteState(
    stage: stage ?? this.stage,
    text: text ?? this.text,
    lines: lines ?? this.lines,
    labels: labels ?? this.labels,
    decisions: decisions ?? this.decisions,
    showAll: showAll ?? this.showAll,
    error: clearError ? null : error ?? this.error,
    build: build ?? this.build,
  );

  @override
  List<Object?> get props => [
    stage,
    text,
    lines,
    labels,
    decisions,
    showAll,
    error,
    build,
  ];
}

class PasteCubit extends Cubit<PasteState> {
  new({
    required this._repository,
    required this._userId,
    this._visibility = RecipeVisibility.friends,
  }) : super(const PasteState());

  static const List<LineKind> cycle = [
    LineKind.title,
    LineKind.serves,
    LineKind.ingredient,
    LineKind.step,
    LineKind.skip,
  ];

  final CreateRepository _repository;
  final String _userId;
  final RecipeVisibility _visibility;

  void setText(String text) =>
      emit(state.copyWith(text: text, clearError: true));

  void split() {
    final text = state.text.trim();
    if (text.isEmpty) {
      emit(state.copyWith(error: PasteMessages.empty));
      return;
    }
    if (text.length > PasteState.maxLength) {
      emit(state.copyWith(error: PasteMessages.tooLong));
      return;
    }
    final lines = RecipeParser.classify(text);
    final parsed = RecipeParser.assemble(lines);
    if (parsed.ingredients.isEmpty && parsed.steps.isEmpty) {
      emit(state.copyWith(error: PasteMessages.nothing));
      return;
    }
    emit(PasteState(stage: PasteStage.review, text: state.text, lines: lines));
  }

  void editText() =>
      emit(state.copyWith(stage: PasteStage.input, clearError: true));

  void relabel(int index) {
    final line = state.lines.firstWhere((l) => l.index == index);
    final current = state.kindOf(line);
    final at = cycle.indexOf(current);
    final next = at == -1
        ? LineKind.ingredient
        : cycle[(at + 1) % cycle.length];
    emit(state.copyWith(labels: {...state.labels, index: next}));
  }

  void decide(int index, {required bool include}) =>
      emit(state.copyWith(decisions: {...state.decisions, index: include}));

  void showAll() => emit(state.copyWith(showAll: true));

  Future<String?> build() async {
    if (state.build.isInProgress) return null;
    emit(state.copyWith(build: const DelayedResult.inProgress()));
    final library = await _repository.library();
    final parsed = state.recipe;
    final servings = parsed.servings;
    final minutes = parsed.totalMinutes;
    final draft = RecipeDraft(
      id: Ids.next(),
      title: (parsed.title ?? '').trim(),
      servings: servings == null
          ? 4
          : servings.clamp(RecipeDraft.minServings, RecipeDraft.maxServings),
      totalMinutes:
          minutes == null || minutes < 1 || minutes > RecipeDraft.maxMinutes
          ? null
          : minutes,
      visibility: _visibility,
      source: RecipeSource.pasted,
      sourceText: state.text.trim(),
      ingredients: [
        for (final i in parsed.ingredients)
          DraftIngredient.fromParsed(Ids.next(), i, library: library),
      ],
      steps: [
        for (final s in parsed.steps) DraftStep(id: Ids.next(), body: s.body),
      ],
    );
    final result = await _repository.save(_userId, draft, library);
    if (isClosed) return null;
    switch (result) {
      case Ok<void>():
        emit(state.copyWith(build: DelayedResult.fromValue(draft.id)));
        return draft.id;
      case Error<void>(:final error):
        emit(state.copyWith(build: DelayedResult.fromError(error.cleanError)));
        return null;
      case CastError<void>(:final error):
        emit(state.copyWith(build: DelayedResult.fromError(error.cleanError)));
        return null;
    }
  }
}
