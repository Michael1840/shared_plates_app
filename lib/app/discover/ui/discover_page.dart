import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../search/ui/filter_page.dart';
import '../../home/ui/items/full_width_card.dart';
import '../../home/ui/items/recipe_item.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';
import 'items/popup_item.dart';

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
  SortingFilter _sorting = SortingFilter.def;

  @override
  void initState() {
    super.initState();

    context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    final String sortingName;

    switch (_sorting) {
      case SortingFilter.def:
        sortingName = 'Default ';
        break;
      case SortingFilter.priceHighToLow:
        sortingName = 'Price high to low ';
        break;
      case SortingFilter.priceLowToHigh:
        sortingName = 'Price low to high ';
        break;
      case SortingFilter.mostServings:
        sortingName = 'Most servings ';
        break;
      case SortingFilter.leastServings:
        sortingName = 'Least servings ';
        break;
    }

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

          final List<RecipeModel> recipes = state.sortRecipes(_sorting);

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
                    PopupMenuButton(
                      menuPadding: EdgeInsets.zero,
                      color: context.container,
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      itemBuilder: (context) => [
                        MyPopupItem(
                          title: 'Default',
                          isBold: _sorting == SortingFilter.def,
                          onTap: () {
                            setState(() {
                              _sorting = SortingFilter.def;
                            });
                          },
                        ),
                        MyPopupItem(
                          title: 'Price low to high',
                          isBold: _sorting == SortingFilter.priceLowToHigh,
                          onTap: () {
                            setState(() {
                              _sorting = SortingFilter.priceLowToHigh;
                            });
                          },
                        ),
                        MyPopupItem(
                          title: 'Price high to low',
                          isBold: _sorting == SortingFilter.priceHighToLow,
                          onTap: () {
                            setState(() {
                              _sorting = SortingFilter.priceHighToLow;
                            });
                          },
                        ),
                        MyPopupItem(
                          title: 'Most servings',
                          isBold: _sorting == SortingFilter.mostServings,
                          onTap: () {
                            setState(() {
                              _sorting = SortingFilter.mostServings;
                            });
                          },
                        ),
                        MyPopupItem(
                          title: 'Least servings',
                          isBold: _sorting == SortingFilter.leastServings,
                          onTap: () {
                            setState(() {
                              _sorting = SortingFilter.leastServings;
                            });
                          },
                        ),
                      ],
                      child: Row(
                        children: [
                          const AppText.secondary(text: 'Sort: ', size: 12),
                          AppText.heading(
                            text: sortingName,
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
                    // Row(
                    //   children: [
                    //     const AppText.secondary(text: 'Sort: ', size: 12),
                    //     AppText.heading(
                    //       text: 'Default ',
                    //       size: 12,
                    //       color: context.textSecondary,
                    //     ),
                    //     Icon(
                    //       MyIcons.arrow_down_up,
                    //       color: context.textSecondary,
                    //       size: 18,
                    //     ),
                    //   ],
                    // ),
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
