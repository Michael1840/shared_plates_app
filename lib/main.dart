import 'package:flutter/material.dart';

import 'app/core/data/helpers/token_storage.dart';
import 'app/core/router/routes.dart';
import 'app/core/theme/theme.dart';

final TokenStorage tokenStorage = TokenStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shared Plates',
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: NavigationRouter.router,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.05,
        );
        return SafeArea(
          top: false,
          bottom: true,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scale),
            child: child!,
          ),
        );
      },
    );
  }
}
