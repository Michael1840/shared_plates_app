import 'package:flutter/material.dart';

import '../../recipe/data/models/recipe_model.dart';

const String sharedPlatesSvg = 'assets/svgs/shared-plates-logo.svg';
const String appleSvg = 'assets/svgs/apple.svg';
const String googleSvg = 'assets/svgs/google.svg';
const String onboarding1Dark = 'assets/svgs/onboard-1-dark.svg';
const String onboarding2Dark = 'assets/svgs/onboard-2-dark.svg';
const String onboarding3Dark = 'assets/svgs/onboard-3-dark.svg';
const String onboarding1Light = 'assets/svgs/onboard-1-dark.svg';
const String onboarding2Light = 'assets/svgs/onboard-2-dark.svg';
const String onboarding3Light = 'assets/svgs/onboard-3-dark.svg';

const String onboarding1 = 'assets/svgs/onboarding-1.svg';
const String onboarding2 = 'assets/svgs/onboarding-2.svg';
const String onboarding3 = 'assets/svgs/onboarding-3.svg';

String onboardingAsset(BuildContext context, int index) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  switch (index) {
    case 1:
      return isDark ? onboarding1Dark : onboarding1Light;
    case 2:
      return isDark ? onboarding2Dark : onboarding2Light;
    case 3:
      return isDark ? onboarding3Dark : onboarding3Light;
    default:
      throw Exception('Invalid onboarding index');
  }
}

List<RecipeModel> kRecipes = [
  RecipeModel(
    id: 11,
    title: 'Consommé de Canard avec une Garniture de Julienne de Légumes',
    cost: 750,
    serves: 2,
    createdBy: '@Chef_Anthelme_Brillat_Savarin_Culinary_Arts',
  ),
  RecipeModel(
    id: 1,
    title: 'Spaghetti Carbonara',
    cost: 260,
    serves: 4,
    createdBy: '@chef_mike',
  ),
  RecipeModel(
    id: 2,
    title: 'Chicken Tikka Masala',
    cost: 434,
    serves: 3,
    createdBy: '@foodie_liz',
  ),
  RecipeModel(
    id: 3,
    title: 'Vegetable Stir-fry',
    cost: 173,
    serves: 2,
    createdBy: '@plant_power',
  ),
  RecipeModel(
    id: 4,
    title: 'Classic Beef Burger',
    cost: 312,
    serves: 1,
    createdBy: '@grill_master',
  ),
  RecipeModel(
    id: 5,
    title: 'Lentil Soup',
    cost: 139,
    serves: 6,
    createdBy: '@soup_lover',
  ),
  RecipeModel(
    id: 6,
    title: 'Shrimp Scampi',
    cost: 521,
    serves: 2,
    createdBy: '@seafood_sam',
  ),
  RecipeModel(
    id: 7,
    title: 'Breakfast Burrito',
    cost: 121,
    serves: 1,
    createdBy: '@morning_eats',
  ),
  RecipeModel(
    id: 8,
    title: 'Roasted Chicken with Herbs',
    cost: 382,
    serves: 4,
    createdBy: '@roast_king',
  ),
  RecipeModel(
    id: 9,
    title: 'Chocolate Chip Cookies',
    cost: 208,
    serves: 12,
    createdBy: '@baking_betty',
  ),
  RecipeModel(
    id: 10,
    title: 'Thai Green Curry',
    cost: 347,
    serves: 3,
    createdBy: '@spicy_thai',
  ),
];
