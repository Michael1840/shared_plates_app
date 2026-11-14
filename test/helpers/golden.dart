import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';

enum GoldenTheme { light, dark }

Future<void> pumpGolden(
  WidgetTester tester,
  Widget child, {
  GoldenTheme theme = GoldenTheme.light,
  Size size = const Size(390, 320),
  EdgeInsets padding = const EdgeInsets.all(20),
}) async {
  tester.view
    ..devicePixelRatio = 2
    ..physicalSize = size * 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme == GoldenTheme.light ? AppTheme.light : AppTheme.dark,
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: app!,
      ),
      home: Scaffold(
        body: DotGridBackground(
          child: Padding(
            padding: padding,
            child: Align(alignment: Alignment.topLeft, child: child),
          ),
        ),
      ),
    ),
  );
  final context = tester.element(find.byType(Scaffold));
  await tester.runAsync(() async {
    for (final mood in PaprikaMood.values) {
      await precacheImage(AssetImage(mood.asset), context);
    }
    await rootBundle.loadString('assets/covers/stew.svg');
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
  await tester.pumpAndSettle();
}
