import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/appbar/sliver_app_bar.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/custom/containers/default_container.dart';
import '../../core/ui/custom/containers/sliver_title.dart';
import '../../core/ui/custom/fields/pinned_sliver_search.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/methods.dart';
import '../../recipe/bloc/recipe_bloc/recipe_bloc.dart';
import '../../recipe/ui/loading_skeleton/recipes_page_skeleton.dart';
import '../bloc/friendship_bloc/friendship_bloc.dart';
import '../data/models/friendship_model.dart';
import 'items/friend_item.dart';
import 'items/friend_request_item.dart';
import 'search/search_page.dart';

enum _FriendPage { friends, requests }

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  _FriendPage _page = _FriendPage.friends;

  Map<int, bool> statusMap = {};

  void _changePage(_FriendPage p) {
    setState(() {
      _page = p;
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<RecipeBloc>().add(RecipeFetchUserRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MainAppBar(),
      body: BlocBuilder<FriendshipBloc, FriendshipState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const RecipesPageSkeleton();
          }

          final List<FriendRequestModel> friends = state.friends;
          final List<FriendRequestModel> requests = state.requests;

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
                context.read<FriendshipBloc>().add(FriendshipsFetch());
              },
              slivers: [
                const CustomSliverAppBar(),

                const CustomSliverTitle(title: 'Friends', subtitle: 'Your'),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          top: 0,
                          bottom: 0,
                          left: _page == _FriendPage.requests
                              ? constraints.maxWidth / 2
                              : 0,
                          right: _page == _FriendPage.friends
                              ? constraints.maxWidth / 2
                              : 0,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.container,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  const DefaultContainer(
                                    radius: 100,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    color: Colors.transparent,
                                    child: Center(
                                      child: AppText.primary(text: 'Friends'),
                                    ),
                                  ).onTap(() {
                                    _changePage(_FriendPage.friends);
                                  }),
                            ),
                            Expanded(
                              child:
                                  const DefaultContainer(
                                    radius: 100,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    color: Colors.transparent,
                                    child: Center(
                                      child: AppText.primary(text: 'Requests'),
                                    ),
                                  ).onTap(() {
                                    _changePage(_FriendPage.requests);
                                  }),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ).paddingBottom(20).toSliver(),

                CustomPinnedSliverSearch(
                  hasIconButton: true,
                  icon: MyIcons.user_add,
                  searchHint: 'Search friends',
                  onTap: () {
                    Methods.showBottomSheet(
                      context,
                      const FriendSearchPage(),
                      isFull: true,
                    );
                  },
                ),

                if (statusMap.isNotEmpty && _page == _FriendPage.requests)
                  Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: WideTextButton(
                              text: 'Confirm',
                              color: context.green,
                            ),
                          ),
                          const Expanded(
                            child: WideTextButton(
                              text: 'Ignore All',
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .slideY(
                        begin: -0.5,
                        end: 0,
                        duration: 150.ms,
                        curve: Curves.linear,
                      )
                      .fadeIn()
                      .paddingBottom(20)
                      .toSliver(),
              ],
              itemBuilder: (context, index) => _page == _FriendPage.friends
                  ? FriendItem(friend: friends[index])
                        .onTap(() {})
                        .paddingBottom((index + 1) == friends.length ? 20 : 0)
                        .listAnimate(index)
                  : FriendRequestItem(
                          request: requests[index],
                          status: statusMap[requests[index].id],
                          onAcceptTap: () {
                            int id = requests[index].id;

                            if (statusMap[id] == true) {
                              statusMap.removeWhere((key, value) => key == id);
                            } else {
                              statusMap[id] = true;
                            }

                            setState(() {});
                          },
                          onRejectTap: () {
                            int id = requests[index].id;

                            if (statusMap[id] == false) {
                              statusMap.removeWhere((key, value) => key == id);
                            } else {
                              statusMap[id] = false;
                            }

                            setState(() {});
                          },
                        )
                        .onTap(() {})
                        .paddingBottom((index + 1) == requests.length ? 20 : 0)
                        .listAnimate(index),
              itemCount: _page == _FriendPage.friends
                  ? friends.length
                  : requests.length,
              gap: 12,
            ),
          );
        },
      ),
    );
  }
}
