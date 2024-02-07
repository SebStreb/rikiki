import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';

class ConfigDialog extends StatefulWidget {
  const ConfigDialog({super.key});

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  final jokerController = TextEditingController();
  final winPointsController = TextEditingController();
  final trickValController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    jokerController.dispose();
    winPointsController.dispose();
    trickValController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    jokerController.text = viewModel.config.numberOfJokers.toString();
    winPointsController.text = viewModel.config.winningPoints.toString();
    trickValController.text = viewModel.config.trickValue.toString();

    return AlertDialog(
      title: const Text("Configure game parameters"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: jokerController,
              decoration: const InputDecoration(labelText: "Number of jokers"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => int.parse(value!) <= 0 ? "Number of jokers should be positive" : null,
            ),
            TextFormField(
              controller: winPointsController,
              decoration: const InputDecoration(labelText: "Points for winning a bet"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => int.parse(value!) <= 0 ? "Winning point should be positive" : null,
            ),
            TextFormField(
              controller: trickValController,
              decoration: const InputDecoration(labelText: "Point value of a trick"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => int.parse(value!) <= 0 ? "Trick value should be positive" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              viewModel.config.numberOfJokers = int.parse(jokerController.text);
              viewModel.config.winningPoints = int.parse(winPointsController.text);
              viewModel.config.trickValue = int.parse(trickValController.text);
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
      ],
    );
  }
}
