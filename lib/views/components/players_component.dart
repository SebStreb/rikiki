import 'package:flutter/material.dart';

import '../../view_models/game_view_model.dart';
import '../dialogs/error_dialog.dart';

class PlayersComponent extends StatefulWidget {
  final List<String> players;
  final void Function(String) addPlayer;
  final void Function(int) removePlayer;
  final void Function(int, int) movePlayer;

  const PlayersComponent({
    super.key,
    required this.players,
    required this.addPlayer,
    required this.removePlayer,
    required this.movePlayer,
  });

  @override
  State<PlayersComponent> createState() => _PlayersComponentState();
}

class _PlayersComponentState extends State<PlayersComponent> {
  final newPlayerController = TextEditingController();
  final focusNode = FocusNode();

  void addNewPlayer() {
    if (widget.players.contains(newPlayerController.text)) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
            message: "There is already a player with this name."),
      );
    } else if (newPlayerController.text == "") {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(message: "Name can't be empty"),
      );
    } else {
      widget.addPlayer(newPlayerController.text);
      newPlayerController.text = "";
    }
  }

  @override
  void dispose() {
    newPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonPlayers = GameViewModel.commonPlayers
        .where((element) => !widget.players.contains(element))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: widget.players.isEmpty
              ? const Center(child: Text("No players yet…"))
              : ReorderableListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    key: ValueKey(widget.players[index]),
                    leading: IconButton(
                      onPressed: () => widget.removePlayer(index),
                      icon: const Icon(Icons.remove_circle),
                    ),
                    title: Text(widget.players[index]),
                  ),
                  itemCount: widget.players.length,
                  onReorder: (oldIndex, newIndex) =>
                      widget.movePlayer(oldIndex, newIndex),
                ),
        ),
        ListTile(
          leading: IconButton(
            onPressed: addNewPlayer,
            icon: const Icon(Icons.add_circle),
          ),
          title: TextFormField(
            controller: newPlayerController,
            decoration: const InputDecoration(labelText: "New player name"),
            autofocus: true,
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              addNewPlayer();
              focusNode.requestFocus();
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 8,),
              itemCount: commonPlayers.length,
              itemBuilder: (context, index) {
                final player = commonPlayers[index];
                return ElevatedButton(
                  onPressed: () => widget.addPlayer(player),
                  child: Text(player),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
