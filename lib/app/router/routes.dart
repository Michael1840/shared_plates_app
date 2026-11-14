abstract final class Routes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const onboarding = '/onboarding';
  static const onboardingYou = '/onboarding/you';
  static const onboardingTaste = '/onboarding/taste';
  static const onboardingFriends = '/onboarding/friends';
  static const home = '/home';
  static const discover = '/discover';
  static const recipes = '/recipes';
  static const friends = '/friends';
  static const create = '/create';
  static const gallery = '/gallery';
  static const search = '/search';
  static const recipe = '/recipe/:id';
  static const cook = 'cook';
  static const cooked = 'cooked';

  static String recipeFor(String id) => '/recipe/$id';

  static String cookFor(String id) => '/recipe/$id/$cook';

  static String cookedFor(String id) => '/recipe/$id/$cooked';
}

abstract final class RouteNames {
  static const splash = 'splash';
  static const welcome = 'welcome';
  static const signIn = 'sign-in';
  static const onboardingYou = 'onboarding-you';
  static const onboardingTaste = 'onboarding-taste';
  static const onboardingFriends = 'onboarding-friends';
  static const home = 'home';
  static const discover = 'discover';
  static const recipes = 'recipes';
  static const friends = 'friends';
  static const create = 'create';
  static const gallery = 'gallery';
  static const search = 'search';
  static const recipe = 'recipe';
  static const cook = 'cook';
  static const cooked = 'cooked';
}
