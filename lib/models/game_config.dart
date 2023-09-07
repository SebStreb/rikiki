class GameConfig {
  static const basicDeckSize = 52;

  var numberOfJokers = 3;
  var winningPoints = 5;
  var trickValue = 2;

  get numberOfCards => basicDeckSize + numberOfJokers;

  int maximumHandSize(int numberOfPlayers) => ((numberOfCards - 1) / numberOfPlayers).toInt();
}
