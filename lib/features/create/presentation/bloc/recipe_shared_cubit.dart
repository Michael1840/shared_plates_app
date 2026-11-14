import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';

class RecipeSharedState extends Equatable {
  const new({this.card, this.count = 0, this.loaded = false});

  static const boxSize = 5;

  final RecipeCard? card;
  final int count;
  final bool loaded;

  int get inBox => count == 0 ? 0 : (count - 1) % boxSize + 1;

  int get toFill => boxSize - inBox;

  @override
  List<Object?> get props => [card, count, loaded];
}

class RecipeSharedCubit extends Cubit<RecipeSharedState> {
  new({
    required this._repository,
    required this._recipeId,
    required this._userId,
  }) : super(const RecipeSharedState());

  final CreateRepository _repository;
  final String _recipeId;
  final String _userId;

  Future<void> load() async {
    final card = await _repository.card(_recipeId, _userId);
    final count = await _repository.publishedCount(_userId);
    if (!isClosed) {
      emit(RecipeSharedState(card: card, count: count, loaded: true));
    }
  }
}
