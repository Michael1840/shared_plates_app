import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';

class FriendsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      header: PaprikaHeader(
        title: 'Friends',
        note: 'your kitchen crew',
        mood: PaprikaMood.cheer,
        tone: HeaderTone.herb,
        search: SpSearchBar(hint: 'Find friends', onTap: () {}),
      ),
      children: const [
        StickyNote(
          body: 'Add friends to see what they cook.',
          mood: PaprikaMood.cheer,
        ),
      ],
    );
  }
}
