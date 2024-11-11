import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_models/game_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Rikiki Game Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: viewModel.playersByScore.length,
                  itemBuilder: (context, index) {
                    var score = viewModel.playersByScore[index];
                    return ListTile(
                      title: Text(score.first),
                      trailing: Text("${score.second} points"),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
              const SizedBox(height: 16),
              Text(viewModel.winners().length == 1
                  ? "The winner is ${viewModel.winners().first}!"
                  : "The winners are: ${viewModel.winners().reduce((player1, player2) => "$player1, $player2")}"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Provider.of<GameViewModel>(context, listen: false).gameStarted = false;
                  context.go("/");
                },
                child: const Text("Start a new game"),
              ),
              if (!kIsWeb && Platform.isIOS) const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
