import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';

class Person extends Equatable {
  const new({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarPath,
    this.bio,
    this.city,
  });

  factory fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as String,
    username: json['username'] as String? ?? '',
    displayName: json['display_name'] as String? ?? '',
    avatarPath: json['avatar_path'] as String?,
    bio: json['bio'] as String?,
    city: json['city'] as String?,
  );

  final String id;
  final String username;
  final String displayName;
  final String? avatarPath;
  final String? bio;
  final String? city;

  String get initials {
    final letters = Formatters.initials(displayName);
    return letters.isEmpty ? '?' : letters;
  }

  String get firstName {
    final first = displayName.trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? '@$username' : first;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'display_name': displayName,
    'avatar_path': avatarPath,
    'bio': bio,
    'city': city,
  };

  @override
  List<Object?> get props => [id, username, displayName, avatarPath, bio, city];
}

enum FriendLink { none, friends, incoming, outgoing }

class Friendship extends Equatable {
  const new({required this.person, required this.link, required this.since});

  final Person person;
  final FriendLink link;
  final DateTime since;

  @override
  List<Object?> get props => [person, link, since];
}

class FriendsOverview extends Equatable {
  const new({
    this.friends = const [],
    this.incoming = const [],
    this.outgoing = const [],
    this.feed = const [],
  });

  final List<Friendship> friends;
  final List<Friendship> incoming;
  final List<Friendship> outgoing;
  final List<RecipeCard> feed;

  int newFrom(String authorId, DateTime since) => feed
      .where(
        (c) =>
            c.authorId == authorId &&
            (c.publishedAt ?? c.updatedAt).isAfter(since),
      )
      .length;

  @override
  List<Object?> get props => [friends, incoming, outgoing, feed];
}

class PersonProfile extends Equatable {
  const new({
    required this.person,
    required this.link,
    this.recipes = const [],
    this.tags = const [],
    this.recipeTags = const {},
  });

  final Person person;
  final FriendLink link;
  final List<RecipeCard> recipes;
  final List<Tag> tags;
  final Map<String, Set<int>> recipeTags;

  int get totalSaves => recipes.fold(0, (sum, r) => sum + r.saveCount);

  PersonProfile withLink(FriendLink next) => PersonProfile(
    person: person,
    link: next,
    recipes: recipes,
    tags: tags,
    recipeTags: recipeTags,
  );

  @override
  List<Object?> get props => [person, link, recipes, tags, recipeTags];
}
