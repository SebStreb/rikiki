import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Rikiki Game Results")),
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
                onPressed: () => Navigator.pushReplacementNamed(context, "/start"),
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
