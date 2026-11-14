import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';

class RecipesPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      header: PaprikaHeader(
        title: 'Your recipes',
        note: 'all yours',
        mood: PaprikaMood.proud,
        search: SpSearchBar(hint: 'Search your recipes', onTap: () {}),
      ),
      children: const [
        StickyNote(
          body: 'Saved and created recipes live here, even offline.',
          mood: PaprikaMood.proud,
        ),
      ],
    );
  }
}
