import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/presentation/bloc/friends_cubit.dart';
import 'package:shared_plates_app/features/friends/presentation/widgets/friends_sections.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final uid = session.userId;
    if (session.status != SessionStatus.signedIn || uid == null) {
      return const _GuestFriends();
    }
    return BlocProvider(
      key: ValueKey(uid),
      create: (_) {
        final cubit = FriendsCubit(
          friends: sl<FriendsRepository>(),
          browse: sl<BrowseRepository>(),
          userId: uid,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const FriendsView(),
    );
  }
}

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  static Future<void> invite() => SharePlus.instance.share(
    ShareParams(
      subject: 'Cook with me on SharedPlates',
      text:
          "I'm sharing recipes on SharedPlates. Come cook with me: "
          '${Env.shareBaseUrl}',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FriendsCubit>().state;
    final cubit = context.read<FriendsCubit>();
    final data = state.data;
    final count = data?.friends.length ?? 0;
    return BlocListener<FriendsCubit, FriendsState>(
      listenWhen: (a, b) => a.errorTick != b.errorTick,
      listener: (context, s) {
        final error = s.error;
        if (error != null) context.showSnackBarError(error);
      },
      child: Scaffold(
        body: TabPage(
          onRefresh: cubit.load,
          header: PaprikaHeader(
            title: 'Friends',
            tone: HeaderTone.herb,
            mood: PaprikaMood.cheer,
            note: count == 0
                ? 'cooking is better shared'
                : '$count ${count == 1 ? 'kitchen' : 'kitchens'} and counting',
            actions: [_InviteButton(onTap: () => unawaited(invite()))],
            search: SpSearchBar(
              hint: 'Find people by name or @username',
              onChanged: cubit.search,
            ),
          ),
          children: [
            if (state.searching)
              const PeopleResults()
            else if (state.overview.isInProgress || state.overview.isIdle)
              const _FriendsSkeleton()
            else if (data == null)
              EmptyState(
                mood: PaprikaMood.oops,
                title: BrowseMessages.titleFor(state.overview.error),
                body: state.overview.error ?? '',
                actions: [CompactButton(label: 'Try again', onTap: cubit.load)],
              )
            else ...[
              if (state.overview.isStale)
                StatusNote.offline().paddingOnly(bottom: Spacing.l),
              if (data.incoming.isNotEmpty)
                RequestsSection(requests: data.incoming),
              if (data.feed.isNotEmpty) JustCooked(cards: data.feed),
              if (data.friends.isNotEmpty)
                FriendList(overview: data)
              else
                _NoFriends(onInvite: () => unawaited(invite())),
              if (data.outgoing.isNotEmpty) SentRequests(sent: data.outgoing),
            ],
          ],
        ),
      ),
    );
  }
}

class _InviteButton extends StatelessWidget {
  const _InviteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeaderFriends;
    return Pressable(
      onTap: onTap,
      child: Container(
        height: Sizes.minTap,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(Rounding.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            SpIcon(SpIcons.share, size: 18, color: context.sp.headerFriends),
            AppText(
              text: 'Invite',
              config: FontConfigs.button2,
              color: context.sp.headerFriends,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoFriends extends StatelessWidget {
  const _NoFriends({required this.onInvite});

  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      mood: PaprikaMood.wink,
      title: 'No friends here yet',
      body:
          'Search for people above or invite someone you cook with. Friends '
          'see the recipes you share with them.',
      actions: [CompactButton(label: 'Invite a friend', onTap: onInvite)],
    );
  }
}

class _FriendsSkeleton extends StatelessWidget {
  const _FriendsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: Column(
        spacing: Spacing.s,
        children: [
          Skeleton(width: 160, height: 22),
          Skeleton(height: 120, radius: Rounding.card),
          Skeleton(width: 140, height: 22),
          Skeleton(height: 200, radius: Rounding.card),
        ],
      ),
    );
  }
}

class _GuestFriends extends StatelessWidget {
  const _GuestFriends();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabPage(
        header: const PaprikaHeader(
          title: 'Friends',
          tone: HeaderTone.herb,
          mood: PaprikaMood.cheer,
        ),
        children: [
          EmptyState(
            mood: PaprikaMood.wink,
            title: 'Cook with friends',
            body: 'Make an account to add friends and see what they cook.',
            actions: [
              CompactButton(
                label: 'Sign in',
                onTap: () =>
                    unawaited(context.read<SessionCubit>().leaveGuest()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
