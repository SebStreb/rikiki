import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'view_models/game_view_model.dart';
import 'views/screens/game_screen.dart';
import 'views/screens/result_screen.dart';
import 'views/screens/start_screen.dart';

void main() {
  usePathUrlStrategy();
  runApp(ChangeNotifierProvider<GameViewModel>(
    create: (context) => GameViewModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rikiki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: "/",
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => const StartScreen(),
          ),
          GoRoute(
            path: "/game",
            builder: (context, state) => const GameScreen(),
          ),
          GoRoute(
            path: "/result",
            builder: (context, state) => const ResultScreen(),
          ),
        ],
        redirect: (context, state) {
          final gameViewModel =
              Provider.of<GameViewModel>(context, listen: false);
          if (!gameViewModel.gameStarted && state.fullPath != "/") return "/";
          return null;
        },
      ),
    );
  }
}
