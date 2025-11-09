import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/custom/containers/tag_container.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';

class FilterHomePage extends StatefulWidget {
  const FilterHomePage({super.key});

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController _searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  const AppText.primary(text: 'Category', size: 16),
                  Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 12,
                    spacing: 12,
                    alignment: WrapAlignment.start,
                    children: [
                      for (final category in kCategories)
                        TagContainer(
                          title: category,
                          // isActive: state.category.contains(category),
                          onTap: () {
                            // cubit.updateCategory(category);
                          },
                        ),
                    ],
                  ),
                  const AppText.primary(text: 'Diet', size: 16),
                  Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 12,
                    spacing: 12,
                    alignment: WrapAlignment.start,
                    children: [
                      for (final diet in kDiets)
                        TagContainer(
                          title: diet,
                          // isActive: state.diet.contains(diet),
                          onTap: () {
                            // cubit.updateDiet(diet);
                          },
                        ),
                    ],
                  ),
                  const AppText.primary(text: 'Cuisine', size: 16),
                  Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 12,
                    spacing: 12,
                    alignment: WrapAlignment.start,
                    children: [
                      for (final cuisine in kCuisines)
                        TagContainer(
                          title: cuisine,
                          // isActive: state.cuisine.contains(cuisine),
                          onTap: () {
                            // cubit.updateCuisine(cuisine);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          WideTextButton(
            text: 'Apply Filters',
            // onTap: create,
            // disabled: !canCreate || !state.canCreate,
            // isLoading: recipeState.isUserLoading,
          ),
        ],
      ),
    );
  }
}
