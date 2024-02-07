import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';
import 'package:rikiki_multiplatform/views/dialogs/error_dialog.dart';

class TricksComponent extends StatefulWidget {
  const TricksComponent({super.key});

  @override
  State<TricksComponent> createState() => _TricksComponentState();
}

class _TricksComponentState extends State<TricksComponent> {
  final Map<String, int> tricks = {};

  int get sum => tricks.isNotEmpty ? tricks.values.reduce((a, b) => a + b) : 0;

  @override
  void initState() {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    for (var player in viewModel.playersFromFirst) {
      tricks[player] = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) => Column(
        children: [
          const Text("Enter your results",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current hand size : ${viewModel.currentHandSize} "
                "${viewModel.downAfter ? "↓" : "↑"}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => viewModel.changeBets(),
                child: const Text("Change bets"),
              )

              /*
              Row(
                children: [
                  IconButton(
                    onPressed: () => viewModel.changeBets(),
                    icon: const Icon(Icons.arrow_circle_left_outlined),
                  ),
                  Text(
                    "Round n°${viewModel.activeRound!.roundNumber}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "Hand size: ${viewModel.activeRound!.handSize}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

               */
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: viewModel.playersFromFirst.length,
              itemBuilder: (context, index) {
                var player = viewModel.playersFromFirst[index];
                return Row(
                  children: [
                    Expanded(child: Text(player)),
                    Expanded(
                        child: Text(
                            "Bet: ${viewModel.activeRound!.bets[player]}")),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: "0",
                        onChanged: (value) =>
                            setState(() => tricks[player] = int.parse(value)),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (sum != viewModel.activeRound!.handSize) {
                  showDialog(
                    context: context,
                    builder: (context) => const ErrorDialog(
                        message:
                            "The total number of tricks must be equal to the hand size."),
                  );
                } else {
                  var done = viewModel.saveTricks(tricks);
                  if (done) Navigator.pushReplacementNamed(context, "/result");
                }
              },
              child: const Text("Confirm results"),
            ),
          ),
          if (!kIsWeb && Platform.isIOS) const SizedBox(height: 16),
        ],
      ),
    );
  }
}
