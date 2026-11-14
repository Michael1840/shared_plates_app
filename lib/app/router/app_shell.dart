import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/floating_tab_bar.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  static const tabs = [
    TabItem(label: 'Home', icon: SpIcons.home),
    TabItem(label: 'Discover', icon: SpIcons.discover),
    TabItem(label: 'Recipes', icon: SpIcons.recipes),
    TabItem(label: 'Friends', icon: SpIcons.friends),
  ];

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: DotGridBackground(child: shell),
      bottomNavigationBar: FloatingTabBar(
        items: tabs,
        currentIndex: shell.currentIndex,
        onSelect: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        onCreate: () => context.push(Routes.create),
      ),
    );
  }
}
