import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rikiki_multiplatform/models/game_config.dart';
import 'package:rikiki_multiplatform/models/round.dart';

enum Steps { bet, trick }

class GameViewModel extends ChangeNotifier {
  var config = GameConfig();

  late List<String> players;

  Round? activeRound;

  var goingDown = false;

  final previousRounds = <Round>[];

  var step = Steps.bet;

  bool get isOver => activeRound == null;

  int get currentHandSize => activeRound?.handSize ?? 0;

  bool get downAfter {
    if (goingDown) return true;
    return currentHandSize == config.maximumHandSize(players.length);
  }

  void start(List<String> players) {
    this.players = players;
    activeRound =
        Round.first(startingPlayerIndex: Random().nextInt(players.length));
    goingDown = false;
    previousRounds.clear();
    step = Steps.bet;
    notifyListeners();
  }

  void changePlayers(List<String> players) {
    this.players = players;
    notifyListeners();
  }

  String? get firstPlayer {
    if (activeRound == null) return null;
    return players[activeRound!.firstPlayerIndex];
  }

  String? get lastPlayer {
    if (activeRound == null) return null;
    if (activeRound!.firstPlayerIndex == 0) return players[players.length - 1];
    return players[activeRound!.firstPlayerIndex - 1];
  }

  List<String> get playersFromFirst {
    var list = <String>[];

    for (var index = players.indexOf(firstPlayer!);
        index < players.length;
        index++) {
      list.add(players[index]);
    }
    for (var index = 0; index < players.indexOf(firstPlayer!); index++) {
      list.add(players[index]);
    }

    return list;
  }

  List<Pair<String, int>> get playersByScore {
    var scores =
        players.map((player) => Pair(player, points[player]!)).toList();
    scores.sort((score1, score2) => score2.second - score1.second);
    return scores;
  }

  Map<String, int> get points => previousRounds.isNotEmpty
      ? previousRounds
          .map((round) => {
                for (var player in players)
                  player: round.getPoints(player, config)
              })
          .reduce((pointsA, pointsB) => {
                for (var player in players)
                  player: pointsA[player]! + pointsB[player]!
              })
      : {for (var player in players) player: 0};

  List<String> winners() {
    var bestPlayers = <String>[];
    var bestPoints = double.negativeInfinity;

    for (var items in points.entries) {
      if (bestPoints < items.value) {
        bestPoints = items.value.toDouble();
        bestPlayers = [items.key];
      } else if (bestPoints == items.value) {
        bestPlayers.add(items.key);
      }
    }

    return bestPlayers;
  }

  void saveBets(Map<String, int> bets) {
    if (activeRound == null || step != Steps.bet) return;
    activeRound!.bets = bets;
    step = Steps.trick;
    notifyListeners();
  }

  bool saveTricks(Map<String, int> tricks) {
    if (activeRound == null || step != Steps.trick) return true;

    activeRound!.tricks = tricks;

    if (goingDown && currentHandSize == 1) {
      previousRounds.add(activeRound!);
      activeRound = null;
      return true;
    }

    if (currentHandSize == config.maximumHandSize(players.length)) {
      goingDown = true;
    }

    var newRound = Round(
      roundNumber: activeRound!.roundNumber + 1,
      handSize:
          goingDown ? currentHandSize - 1 : currentHandSize + 1,
      firstPlayerIndex: (activeRound!.firstPlayerIndex + 1) % players.length,
    );

    previousRounds.add(activeRound!);
    activeRound = newRound;

    step = Steps.bet;

    notifyListeners();

    return false;
  }

  void changeBets() {
    step = Steps.bet;
    notifyListeners();
  }

  void goDownInstead() {
    goingDown = true;
    activeRound = Round(
      roundNumber: activeRound!.roundNumber,
      handSize: currentHandSize - 2,
      firstPlayerIndex: activeRound!.firstPlayerIndex,
    );
    notifyListeners();
  }
}

class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);
}
