import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/custom_bottom_sheet_button.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../home/ui/items/full_width_card.dart';
import '../../home/ui/items/recipe_item.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';
import '../../search/ui/filter_page.dart';

enum _ViewFilter { card, items }

enum SortingFilter {
  priceHighToLow,
  priceLowToHigh,
  def,
  mostServings,
  leastServings,
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  _ViewFilter _filter = _ViewFilter.card;
  FilterValue<SortingFilter> _sorting = kSortingFilters.first;

  @override
  void initState() {
    super.initState();

    context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MainAppBar(),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state.isUserLoading) {
            return const RecipesPageSkeleton();
          }

          if (state.userRecipesResult.value == null) {
            return const RecipesPageSkeleton();
          }

          final List<RecipeModel> recipes = state.sortRecipes(_sorting.value);

          return PageContainer(
            padding: const EdgeInsets.only(
              // top: 20,
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: MySliverList(
              bottomSpacer: true,
              emptyText: 'No recipes found',
              onRefresh: () async {
                context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
              },
              slivers: [
                const CustomSliverAppBar(),

                const CustomSliverTitle(
                  title: 'Your Perfect Dish',
                  subtitle: 'Discover',
                ),

                CustomPinnedSliverSearchContainer(
                  searchHint: 'What are you craving?',
                  onSearchTap: () {
                    Methods.showBottomSheet(
                      context,
                      const FilterHomePage(),
                      isFull: true,
                    );
                  },
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     spacing: 8,
                //     children: [
                //       const TagContainer(title: 'All Categories'),
                //       for (final tag in kCategories) TagContainer(title: tag),
                //     ],
                //   ),
                // ).paddingBottom(20).toSliver(),
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        _filter == _ViewFilter.card
                            ? const MyIconButton.colored(
                                icon: Icons.view_agenda_outlined,
                              )
                            : MyIconButton(
                                icon: Icons.view_agenda_outlined,
                                onTap: () {
                                  setState(() {
                                    _filter = _ViewFilter.card;
                                  });
                                },
                              ),
                        _filter == _ViewFilter.items
                            ? const MyIconButton.colored(
                                icon: MyIcons.menu_alt_04,
                              )
                            : MyIconButton(
                                icon: MyIcons.menu_alt_04,
                                onTap: () {
                                  setState(() {
                                    _filter = _ViewFilter.items;
                                  });
                                },
                              ),
                      ],
                    ),
                    CustomBottomSheetButton<FilterValue<SortingFilter>>(
                      options: kSortingFilters,
                      selected: _sorting,
                      dropdownTitle: 'SORT BY',
                      onChanged: (s) {
                        setState(() {
                          _sorting = s;
                        });
                      },
                      labelBuilder: (s) => s.name,
                      customButton: Row(
                        children: [
                          const AppText.secondary(text: 'Sort: ', size: 12),
                          AppText.heading(
                            text: _sorting.name,
                            size: 12,
                            color: context.textSecondary,
                          ),
                          Icon(
                            MyIcons.arrow_down_up,
                            color: context.textSecondary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ).paddingBottom(20).toSliver(),
              ],
              itemBuilder: (context, index) => _filter == _ViewFilter.card
                  ? FullWidthCard(
                          recipe: recipes[index],
                          onLike: () {
                            context.read<RecipeBloc>().add(
                              LikeRecipe(RecipeType.user, recipes[index].id),
                            );
                          },
                        )
                        .onTap(() {
                          context.pushNamed(
                            Routes.recipeDetail,
                            pathParameters: {
                              'id': recipes[index].id.toString(),
                            },
                          );
                        })
                        .listAnimateHorizontal(index)
                  : RecipeItem(
                          recipe: recipes[index],
                          onLike: () {
                            context.read<RecipeBloc>().add(
                              LikeRecipe(RecipeType.user, recipes[index].id),
                            );
                          },
                        )
                        .onTap(() {
                          context.pushNamed(
                            Routes.recipeDetail,
                            pathParameters: {
                              'id': recipes[index].id.toString(),
                            },
                          );
                        })
                        .listAnimateHorizontal(index),
              itemCount: recipes.length,
            ),
          );
        },
      ),
    );
  }
}
