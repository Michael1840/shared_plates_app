import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';

class DiscoverPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      header: PaprikaHeader(
        title: 'Discover',
        note: 'go on,\nhave a look',
        mood: PaprikaMood.thinking,
        search: SpSearchBar(onTap: () {}, onFilterTap: () {}),
      ),
      children: const [
        StickyNote(
          body: 'Trending dishes and new cooks show up here.',
          mood: PaprikaMood.thinking,
        ),
      ],
    );
  }
}
