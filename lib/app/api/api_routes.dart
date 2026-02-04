part of 'api_helper.dart';

class ApiRoutes {
  static const String stagingUrl =
      'https://sharedplatesapi-staging.up.railway.app/api/v1';

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: stagingUrl,
  );

  static const String tokenRefresh = '/token/refresh/';

  // AUTH

  static const String login = '/login/';
  static const String register = '/register/';
  static const String logout = '/logout/';

  static const String profile = '/profile/';

  // MEALS

  static const String recipe = '/meals/';
  static const String createRecipe = recipe;
  static String recipeWithId(int id) => '$recipe$id';
  static String likeRecipe(int id) => '$recipe$id/like/';
  static String uploadMealImage(int id) => '$recipe$id/upload-image/';
  static const String userRecipes = recipe;
  static String trendingRecipes({int? length, int? page}) {
    String endPoint = '${recipe}trending/';

    if (page != null && length != null) {
      endPoint = '$endPoint?page=$page&page_size=$length';
    } else if (page != null) {
      endPoint = '$endPoint?page=$page';
    } else if (length != null) {
      endPoint = '$endPoint?page_size=$length';
    }

    return endPoint;
  }

  static String searchMeals({
    int? length,
    int? page,
    String? query,
    String? sorting,
    List<String>? tags,
    bool? matchAllTags,
    int? maxPrice,
    bool? isLiked,
    bool? friendsOnly,
  }) {
    String endPoint = '${recipe}search/';
    List<String> params = [];

    // Add pagination params
    if (page != null) {
      params.add('page=$page');
    }
    if (length != null) {
      params.add('page_size=$length');
    }

    // Add search query
    if (query != null && query.isNotEmpty) {
      params.add('q=${Uri.encodeComponent(query)}');
    }

    // Add tags as comma-separated
    if (tags != null && tags.isNotEmpty) {
      final tagsString = tags.join(',');
      params.add('tags=${Uri.encodeComponent(tagsString)}');
    }

    // Add match_all_tags param
    if (matchAllTags != null && matchAllTags) {
      params.add('match_all_tags=true');
    }

    // Add sorting
    if (sorting != null && sorting.isNotEmpty) {
      params.add('sort=$sorting');
    }

    // Add max_price
    if (maxPrice != null && (maxPrice < 3000 && maxPrice > 0)) {
      params.add('max_price=$maxPrice');
    }

    // Add is_liked param
    if (isLiked != null && isLiked) {
      params.add('is_liked=true');
    }

    if (friendsOnly != null && friendsOnly) {
      params.add('friends_only=true');
    }

    // Combine all params
    if (params.isNotEmpty) {
      endPoint = '$endPoint?${params.join('&')}';
    }

    print(endPoint);

    return endPoint;
  }

  static String friendsRecipes({int? length, int? page}) {
    String endPoint = '${recipe}friends-feed/';

    if (page != null && length != null) {
      endPoint = '$endPoint?page=$page&page_size=$length';
    } else if (page != null) {
      endPoint = '$endPoint?page=$page';
    } else if (length != null) {
      endPoint = '$endPoint?page_size=$length';
    }

    return endPoint;
  }

  // FRIENDS

  static const String friendships = '/friendships/';
  static String searchUsers(String q) => '/users/?query=$q';
  static const String addUser = friendships;
}
