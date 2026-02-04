import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/models/result_model.dart';
import '../../../core/data/models/delayed_result.dart';
import '../../../recipe/data/models/recipe_model.dart';
import '../../../recipe/data/repo/recipe_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final RecipesRepository _recipesRepository;

  SearchCubit(RecipesRepository recipesRepository)
    : _recipesRepository = recipesRepository,
      super(SearchState.initial());

  void toggleTag(String tag) {
    List<String> tags = List.from(state.tags);

    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }

    emit(state.copyWith(tags: tags));
  }

  void reset() {
    emit(SearchState.initial());
  }

  void updateLikedOnly(bool b) {
    emit(state.copyWith(likedOnly: b));
  }

  void updateFriendsOnly(bool b) {
    emit(state.copyWith(friendsOnly: b));
  }

  void updateMatchAllTags(bool b) {
    emit(state.copyWith(matchAllTags: b));
  }

  void searchFilter(String? s) {
    emit(state.copyWith(searchFilter: s));
  }

  void updatePopularityFilter(String s) {
    emit(state.copyWith(popularityFilter: s));
  }

  void updateMaxPrice(double v, int m) {
    emit(state.copyWith(maxPrice: v, actualMaxPrice: m));
  }

  Future<void> search() async {
    emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

    try {
      final Result<List<RecipeModel>> result = await _recipesRepository
          .getSearchResults(
            20,
            1,
            state.searchFilter,
            state.popularityFilter,
            state.tags,
            state.matchAllTags,
            state.actualMaxPrice,
            state.likedOnly,
            state.friendsOnly,
          );

      switch (result) {
        case Error<List<RecipeModel>>():
          throw result.error;
        case CastError<List<RecipeModel>>():
          throw result.error;
        case Ok<List<RecipeModel>>():
      }

      List<RecipeModel> recipes = result.value;

      emit(state.copyWith(loadingResult: DelayedResult.fromValue(recipes)));
    } catch (e) {
      emit(
        state.copyWith(loadingResult: DelayedResult.fromError(e.toString())),
      );
    }
  }
}
