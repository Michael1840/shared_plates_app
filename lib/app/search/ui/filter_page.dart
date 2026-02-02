import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/tag_container.dart';
import '../../core/ui/custom/fields/search_field.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../recipe/data/repo/recipe_repo.dart';
import '../bloc/search_cubit/search_cubit.dart';

class FilterHomePage extends StatefulWidget {
  const FilterHomePage({super.key});

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController _searchCont = TextEditingController();

  late SearchCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = SearchCubit(context.read<RecipesRepository>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return PageContainer(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SearchField(
                        hint: 'Search recipes',
                        controller: _searchCont,
                        onChanged: (s) {
                          context.read<SearchCubit>().searchFilter(s);
                        },
                      ),
                    ),
                    MyIconButton.colored(
                      icon: MyIcons.chevron_right,
                      padding: 14,
                      color: context.green,
                      disabled:
                          (state.searchFilter.isNull ||
                              state.searchFilter!.isEmpty) &&
                          state.tags.isEmpty,
                      onTap: () {
                        final searchCubit = context.read<SearchCubit>();
                        context.pop();

                        Future.delayed(const Duration(milliseconds: 50)).then((
                          value,
                        ) {
                          if (!context.mounted) return;
                          searchCubit.search();
                          context.goNamed(Routes.search, extra: searchCubit);
                        });
                      },
                    ),
                  ],
                ),
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
                                isActive: state.tags.contains(category),
                                onTap: () {
                                  context.read<SearchCubit>().toggleTag(
                                    category,
                                  );
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
                                isActive: state.tags.contains(diet),
                                onTap: () {
                                  context.read<SearchCubit>().toggleTag(diet);
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
                                isActive: state.tags.contains(cuisine),
                                onTap: () {
                                  context.read<SearchCubit>().toggleTag(
                                    cuisine,
                                  );
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // const WideTextButton(
                //   text: 'Explore',
                //   // onTap: create,
                //   // disabled: !canCreate || !state.canCreate,
                //   // isLoading: recipeState.isUserLoading,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
