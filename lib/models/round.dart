import 'package:rikiki_multiplatform/models/game_config.dart';

class Round {
  Round({
    required this.roundNumber,
    required this.handSize,
    required this.firstPlayerIndex,
  });

  Round.first({required startingPlayerIndex})
      : this(
            roundNumber: 1, handSize: 1, firstPlayerIndex: startingPlayerIndex);

  final int roundNumber;
  final int handSize;
  final int firstPlayerIndex;

  var bets = <String, int>{};
  var tricks = <String, int>{};

  int getPoints(String player, GameConfig config) {
    var bet = bets[player] ?? 0;
    var trick = tricks[player] ?? 0;
    var diff = (trick - bet).abs();
    return diff == 0
        ? config.winningPoints + bet * config.trickValue
        : diff * -config.trickValue;
  }
}
