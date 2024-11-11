import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_models/game_view_model.dart';
import '../components/bets_component.dart';
import '../dialogs/config_dialog.dart';
import '../dialogs/players_dialog.dart';
import '../dialogs/points_dialog.dart';
import '../components/tricks_component.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Rikiki Game"),
          leading: IconButton(
            onPressed: () {
              Provider.of<GameViewModel>(context, listen: false)
                  .activeRound = null;
              context.go("/result");
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
