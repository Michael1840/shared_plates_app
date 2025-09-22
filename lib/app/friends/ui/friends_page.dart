import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/containers/default_container.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/data/models/recipe_model.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';
import 'items/friend_item.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
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

                const CustomSliverTitle(title: 'Friends', subtitle: 'Your'),

                Row(
                  children: [
                    const Expanded(
                      child: DefaultContainer(
                        radius: 100,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Center(child: AppText.primary(text: 'Friends')),
                      ),
                    ),
                    Expanded(
                      child: DefaultContainer(
                        radius: 100,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        color: context.background,
                        child: const Center(
                          child: AppText.primary(text: 'Requests'),
                        ),
                      ),
                    ),
                  ],
                ).paddingBottom(20).toSliver(),

                const CustomPinnedSliverSearch(),
              ],
              itemBuilder: (context, index) => const FriendItem()
                  .onTap(() {
                    context.goNamed(
                      Routes.recipeDetail,
                      pathParameters: {'id': recipes[index].id.toString()},
                    );
                  })
                  .paddingBottom((index + 1) == recipes.length ? 20 : 0)
                  .listAnimate(index),
              itemCount: recipes.length,
            ),
          );
        },
      ),
    );
  }
}
