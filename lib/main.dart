import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/api/services/friends_api_service.dart';
import 'app/api/services/recipe_api_service.dart';
import 'app/api/services/user_api_service.dart';
import 'app/auth/blocs/user_bloc/user_bloc.dart';
import 'app/auth/data/repo/user_repo.dart';
import 'app/core/data/helpers/token_storage.dart';
import 'app/core/router/routes.dart';
import 'app/core/theme/theme.dart';
import 'app/friends/data/repo/friends_repo.dart';
import 'app/recipe/data/repo/recipe_repo.dart';

final TokenStorage tokenStorage = TokenStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await tokenStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserDataProvider(UserApiService()),
        ),
        RepositoryProvider<RecipesRepository>(
          create: (context) => RecipesDataProvider(RecipeApiService()),
        ),
        RepositoryProvider<FriendsRepository>(
          create: (context) => FriendshipDataProvider(FriendsApiService()),
        ),
        BlocProvider(
          create: (context) => UserBloc(context.read<UserRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Shared Plates',
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: NavigationRouter.router,
        builder: (context, child) {
          return SafeArea(
            top: !Platform.isIOS,
            // top: true,
            bottom: false,
            // bottom: true,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler
                      .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.05)
                      .scale(1.0),
                ),
              ),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
