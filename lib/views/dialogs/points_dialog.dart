import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/game_view_model.dart';

class PointsDialog extends StatelessWidget {
  const PointsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context, listen: false);
    return AlertDialog(
      title: const Text("Current scores"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
