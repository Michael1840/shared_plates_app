part of 'api_helper.dart';

class ApiRoutes {
  static const String releaseUrl =
      'https://sharedplatesapi-production.up.railway.app/api/v1';
  static const String debugUrl = '';

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
  static String likeRecipe(int id) => '${recipe}like/$id';
  static String uploadMealImage(int id) => '${recipe}upload/$id';
  static const String userRecipes = recipe;
  static String trendingRecipes({int? length, int? page}) {
    String endPoint = '${recipe}trending/';

    if (page != null) {
      endPoint = '$endPoint?page=$page';
    }

    if (length != null) {
      endPoint = '$endPoint?page_size=$length';
    }

    return endPoint;
  }

  static String friendsRecipes({int? length, int? page}) {
    String endPoint = '${recipe}friends/';

    if (page != null) {
      endPoint = '$endPoint?page=$page';
    }

    if (length != null) {
      endPoint = '$endPoint?page_size=$length';
    }

    return endPoint;
  }

  // FRIENDS

  static const String friendships = '/friendships/';
  static String searchUsers(String q) => '/users/?query=$q';
  static const String addUser = friendships;
}
