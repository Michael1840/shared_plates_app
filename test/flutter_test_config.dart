import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _fonts = {
  'BricolageGrotesque': [
    'assets/fonts/BricolageGrotesque-Bold.ttf',
    'assets/fonts/BricolageGrotesque-ExtraBold.ttf',
  ],
  'Inter': [
    'assets/fonts/Inter-Regular.ttf',
    'assets/fonts/Inter-Medium.ttf',
    'assets/fonts/Inter-SemiBold.ttf',
    'assets/fonts/Inter-Bold.ttf',
  ],
  'Caveat': [
    'assets/fonts/Caveat-SemiBold.ttf',
    'assets/fonts/Caveat-Bold.ttf',
  ],
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final entry in _fonts.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }
  await testMain();
}
