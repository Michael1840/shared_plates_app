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

  static const String recipe = '/meals';
  static String recipeWithId(int id) => '/meals/$id';
  static const String userRecipes = '';
  static const String trendingRecipes = '';
  static const String friendsRecipes = '';
}
