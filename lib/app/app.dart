import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/app_router.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';

class SharedPlatesApp extends StatefulWidget {
  const new({super.key});

  @override
  State<SharedPlatesApp> createState() => _SharedPlatesAppState();
}

class _SharedPlatesAppState extends State<SharedPlatesApp> {
  late final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SharedPlates',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
