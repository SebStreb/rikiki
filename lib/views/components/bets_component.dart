import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';
import 'package:rikiki_multiplatform/views/dialogs/error_dialog.dart';

class BetsComponent extends StatefulWidget {
  const BetsComponent({Key? key}) : super(key: key);

  @override
  State<BetsComponent> createState() => _BetsComponentState();
}

class _BetsComponentState extends State<BetsComponent> {
  final Map<String, int> bets = {};

  int get sum => bets.isNotEmpty ? bets.values.reduce((a, b) => a + b) : 0;

  @override
  void initState() {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    for (var player in viewModel.playersFromFirst) {
      bets[player] = viewModel.activeRound!.bets[player] ?? 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) => Column(
        children: [
          const Text("Place your bets",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  !viewModel.goingDown && viewModel.activeRound!.handSize > 2
                      ? IconButton(
                          onPressed: () => viewModel.goDownInstead(),
                          icon: const Icon(Icons.arrow_circle_down),
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                        ),
                  Text(
                    "Round n°${viewModel.activeRound!.roundNumber}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "Hand size: ${viewModel.activeRound!.handSize} ${viewModel.goingDown ? "↓" : "↑"}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue:
                            viewModel.activeRound!.bets[player]?.toString() ??
                                "0",
                        onChanged: (value) =>
                            setState(() => bets[player] = int.parse(value)),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Sum of all bets: $sum",
            style: TextStyle(
                color: sum == viewModel.activeRound!.handSize
                    ? Colors.red
                    : Colors.black),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (sum == viewModel.activeRound!.handSize) {
                  showDialog(
                    context: context,
                    builder: (context) => const ErrorDialog(
                        message:
                            "The sum of all bets can't be equal to the hand size."),
                  );
                } else {
                  viewModel.saveBets(bets);
                }
              },
              child: const Text("Confirm bets"),
            ),
          ),
          if (!kIsWeb && Platform.isIOS) const SizedBox(height: 16),
        ],
      ),
    );
  }
}
