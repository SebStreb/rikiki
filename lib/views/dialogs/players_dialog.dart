import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rikiki_multiplatform/view_models/game_view_model.dart';
import 'package:rikiki_multiplatform/views/components/players_component.dart';
import 'package:rikiki_multiplatform/views/dialogs/error_dialog.dart';

class PlayersDialog extends StatefulWidget {
  const PlayersDialog({super.key});

  @override
  State<PlayersDialog> createState() => _PlayersDialogState();
}

class _PlayersDialogState extends State<PlayersDialog> {
  var players = <String>[];

  @override
  void initState() {
    setState(() => players = Provider.of<GameViewModel>(context, listen: false).players);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Manage players"),
      content: SizedBox(
        width: double.maxFinite,
        child: PlayersComponent(
          players: players,
          addPlayer: (player) => setState(() => players.add(player)),
          removePlayer: (index) => setState(() => players.removeAt(index)),
          movePlayer: (oldIndex, newIndex) => setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            String player = players.removeAt(oldIndex);
            players.insert(newIndex, player);
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (players.length < 2) {
              showDialog(
                context: context,
                builder: (context) => const ErrorDialog(message: "Enter a least two players."),
              );
            } else {
              Provider.of<GameViewModel>(context, listen: false).changePlayers(players);
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
