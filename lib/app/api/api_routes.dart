part of 'api_helper.dart';

class ApiRoutes {
  static const String releaseUrl =
      'https://sharedplatesapi-production.up.railway.app/api/v1';
  static const String debugUrl = '';

  static const String tokenRefresh = '';

  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';

  static const String profile = '/profile';

  static const String recipe = '/meals/';
  static const String createRecipe = recipe;
  static String recipeWithId(int id) => '$recipe$id';
  static String uploadMealImage(int id) => '${recipe}upload/$id';
  static const String userRecipes = recipe;
  static const String trendingRecipes = recipe;
  static const String friendsRecipes = recipe;
}
