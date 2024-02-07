import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';
import 'package:rikiki_multiplatform/views/components/bets_component.dart';
import 'package:rikiki_multiplatform/views/dialogs/config_dialog.dart';
import 'package:rikiki_multiplatform/views/dialogs/players_dialog.dart';
import 'package:rikiki_multiplatform/views/dialogs/points_dialog.dart';
import 'package:rikiki_multiplatform/views/components/tricks_component.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Rikiki Game"),
          leading: IconButton(
            onPressed: () {
              Provider.of<GameViewModel>(context, listen: false).activeRound =
                  null;
              Navigator.pushReplacementNamed(context, "/result");
            },
            icon: const Icon(Icons.cancel),
          ),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                  context: context, builder: (context) => const PointsDialog()),
              icon: const Icon(Icons.scoreboard),
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const PlayersDialog()),
              icon: const Icon(Icons.people),
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context, builder: (context) => const ConfigDialog()),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<GameViewModel>(
            builder: (context, viewModel, child) => viewModel.step == Steps.bet
                ? const BetsComponent()
                : const TricksComponent(),
          ),
        ),
      );
}
