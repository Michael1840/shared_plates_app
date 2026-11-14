import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';

class ProfilePageState extends Equatable {
  const new({this.recipes = const [], this.friendCount, this.loaded = false});

  final List<RecipeCard> recipes;
  final int? friendCount;
  final bool loaded;

  int get savesByOthers => recipes.fold(0, (s, r) => s + r.saveCount);

  int get cooksByOthers => recipes.fold(0, (s, r) => s + r.cookCount);

  ProfilePageState copyWith({
    List<RecipeCard>? recipes,
    int? friendCount,
    bool? loaded,
  }) => ProfilePageState(
    recipes: recipes ?? this.recipes,
    friendCount: friendCount ?? this.friendCount,
    loaded: loaded ?? this.loaded,
  );

  @override
  List<Object?> get props => [recipes, friendCount, loaded];
}

class ProfilePageCubit extends Cubit<ProfilePageState> {
  new({required this._library, required this._friends, required this._userId})
    : super(const ProfilePageState());

  final LibraryRepository _library;
  final FriendsRepository _friends;
  final String _userId;
  StreamSubscription<List<LibraryEntry>>? _sub;

  Future<void> start() async {
    _sub = _library.watch(_userId).listen((entries) {
      if (isClosed) return;
      final mine = [
        for (final e in entries)
          if (e.isMine && e.card.status == RecipeStatus.published) e,
      ]..sort((a, b) => b.addedAt.compareTo(a.addedAt));
      emit(
        state.copyWith(recipes: [for (final e in mine) e.card], loaded: true),
      );
    });
    final result = await _friends.overview(_userId);
    if (isClosed) return;
    if (result case Ok(:final value)) {
      emit(state.copyWith(friendCount: value.value.friends.length));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await super.close();
  }
}
