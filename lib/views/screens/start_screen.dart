import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_models/game_view_model.dart';
import '../components/players_component.dart';
import '../dialogs/error_dialog.dart';
import '../dialogs/config_dialog.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final players = <String>[];

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<GameViewModel>(context, listen: false).config;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Rikiki Game Configuration"),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const ConfigDialog(),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PlayersComponent(
                  players: players,
                  addPlayer: (player) => setState(() => players.add(player)),
                  removePlayer: (index) =>
                      setState(() => players.removeAt(index)),
                  movePlayer: (oldIndex, newIndex) => setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    String player = players.removeAt(oldIndex);
                    players.insert(newIndex, player);
                  }),
                ),
              ),
              const SizedBox(height: 24),
              Text("Maximum hand size: ${players.isEmpty ?
                  "0" : config.maximumHandSize(players.length)}"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (players.length < 2) {
                    showDialog(
                      context: context,
                      builder: (context) => const ErrorDialog(
                          message: "Enter a least two players."),
                    );
                  } else {
                    Provider.of<GameViewModel>(context, listen: false)
                        .start(players);
                    context.go("/game");
                  }
                },
                child: const Text("Start game"),
              ),
              if (!kIsWeb && Platform.isIOS) const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
