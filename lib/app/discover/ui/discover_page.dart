import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/default_container.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/containers/tag_container.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../home/ui/filter_home_page.dart';
import '../../home/ui/items/full_width_card.dart';
import '../../home/ui/items/recipe_item.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';

enum _Filter { card, items }

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  _Filter _filter = _Filter.card;

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

          int length = 5;
          final List<RecipeModel> recipes = state.userRecipesResult.value!;

          if (recipes.length < length) {
            length = recipes.length;
          }

          return PageContainer(
            padding: const EdgeInsets.only(
              // top: 20,
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: MySliverList(
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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: [
                      const TagContainer(title: 'All Categories'),
                      for (final tag in kCategories) TagContainer(title: tag),
                    ],
                  ),
                ).paddingBottom(20).toSliver(),

                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        _filter == _Filter.card
                            ? const MyIconButton.colored(
                                icon: Icons.view_agenda_outlined,
                              )
                            : MyIconButton(
                                icon: Icons.view_agenda_outlined,
                                onTap: () {
                                  setState(() {
                                    _filter = _Filter.card;
                                  });
                                },
                              ),
                        _filter == _Filter.items
                            ? const MyIconButton.colored(
                                icon: MyIcons.menu_alt_04,
                              )
                            : MyIconButton(
                                icon: MyIcons.menu_alt_04,
                                onTap: () {
                                  setState(() {
                                    _filter = _Filter.items;
                                  });
                                },
                              ),
                      ],
                    ),
                    DefaultContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            MyIcons.slider_02,
                            color: context.textSecondary,
                            size: 16,
                          ),
                          AppText.secondary(text: 'Filter', size: 14),
                        ],
                      ),
                    ),
                  ],
                ).paddingBottom(20).toSliver(),

                // ViewAllRow(title: 'Hot This Week', onTap: () {}).toSliver(),
                // SizedBox(
                //       height: 230,
                //       child: MySliverList.horizontal(
                //         itemBuilder: (context, index) =>
                //             TrendingRecipeItem(recipe: recipes[index])
                //                 .onTap(() {
                //                   context.pushNamed(
                //                     Routes.dashRecipeDetail,
                //                     pathParameters: {
                //                       'id': recipes[index].id.toString(),
                //                     },
                //                   );
                //                 })
                //                 .listAnimateHorizontal(index),
                //         itemCount: length,
                //       ),
                //     )
                //     .paddingSymmetric(vertical: 20)
                //     .animate()
                //     .slideX(
                //       begin: 1,
                //       end: 0,
                //       delay: 250.ms,
                //       // alignment: Alignment.centerLeft,
                //     )
                //     .toSliver(),
                // ViewAllRow(title: 'Under R100', onTap: () {}).toSliver(),
                // SizedBox(
                //       height: 230,
                //       child: MySliverList.horizontal(
                //         itemBuilder: (context, index) =>
                //             TrendingRecipeItem(recipe: recipes[index])
                //                 .onTap(() {
                //                   context.pushNamed(
                //                     Routes.dashRecipeDetail,
                //                     pathParameters: {
                //                       'id': recipes[index].id.toString(),
                //                     },
                //                   );
                //                 })
                //                 .listAnimateHorizontal(index),
                //         itemCount: length,
                //       ),
                //     )
                //     .paddingSymmetric(vertical: 20)
                //     .animate()
                //     .slideX(
                //       begin: 1,
                //       end: 0,
                //       delay: 250.ms,
                //       // alignment: Alignment.centerLeft,
                //     )
                //     .toSliver(),
              ],
              itemBuilder: (context, index) => _filter == _Filter.card
                  ? FullWidthCard(recipe: recipes[index], onLike: () {})
                        .onTap(() {
                          context.pushNamed(
                            Routes.dashRecipeDetail,
                            pathParameters: {
                              'id': recipes[index].id.toString(),
                            },
                          );
                        })
                        .listAnimateHorizontal(index)
                  : RecipeItem(recipe: recipes[index])
                        .onTap(() {
                          context.pushNamed(
                            Routes.dashRecipeDetail,
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
