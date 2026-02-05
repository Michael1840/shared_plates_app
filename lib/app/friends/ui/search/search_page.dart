import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../../api/models/result_model.dart';
import '../../../core/ui/custom/animations/ball_animation.dart';
import '../../../core/ui/custom/containers/empty_container.dart';
import '../../../core/ui/custom/containers/my_list.dart';
import '../../../core/ui/custom/fields/search_field.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../bloc/search_users_cubit/search_users_cubit.dart';
import '../../data/repo/friends_repo.dart';
import 'search_item.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({super.key});

  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  final Debouncer _debouncer = Debouncer();

  final TextEditingController _searchCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchUsersCubit(context.read<FriendsRepository>()),
      child: BlocBuilder<SearchUsersCubit, SearchUsersState>(
        builder: (context, state) {
          final cubit = context.read<SearchUsersCubit>();

          return Column(
            spacing: 20,
            children: [
              SearchField(
                controller: _searchCont,
                hint: 'Add friends',
                onChanged: (s) {
                  _debouncer.debounce(
                    duration: const Duration(milliseconds: 250),
                    type: BehaviorType.leadingEdge,
                    onDebounce: () {
                      if (s.isNotEmpty) {
                        cubit.searchUsers(s);
                      }
                    },
                  );
                },
              ),
              Expanded(
                child: state.isLoading
                    ? const BallAnimation(ballSize: 10)
                    : state.results.isEmpty
                    ? const Center(child: EmptyContainer(icon: MyIcons.user_03))
                    : MyList(
                        count: state.results.length,

                        itemBuilder: (context, index) => SearchFriendItem(
                          user: state.results[index],
                          followUser: () async {
                            final result = await cubit.addUser(
                              state.results[index].username,
                            );

                            if (!context.mounted) return;

                            switch (result) {
                              case Error<void>():
                                context.showSnackBarError(
                                  result.error.toString(),
                                );
                              case CastError<void>():
                                context.showSnackBarError(
                                  result.error.toString(),
                                );
                              case Ok<void>():
                                context.showSnackBarMessage(
                                  'Friend request sent successfully',
                                );
                            }
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
