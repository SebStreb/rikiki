import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';
import 'package:rikiki_multiplatform/views/screens/game_screen.dart';
import 'package:rikiki_multiplatform/views/screens/result_screen.dart';
import 'package:rikiki_multiplatform/views/screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameViewModel>(
      create: (context) => GameViewModel(),
      child: MaterialApp(
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
        initialRoute: "/start",
        routes: {
          "/start": (context) => const StartScreen(),
          "/game": (context) => const GameScreen(),
          "/result": (context) => const ResultScreen(),
        },
      ),
    );
  }
}
