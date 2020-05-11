enum Player {
  A,
  B
}

String playerToString(Player player) {
  switch(player) {
    case Player.A: {
      return "Player.A";
    }
    break;

    case Player.B: {
      return "Player.B";
    }
    break;
  }
}

Player switchPlayers(Player player) {
  switch(player) {
    case Player.A: {
      return Player.B;
    }
    break;

    case Player.B: {
      return Player.A;
    }
    break;
  }
}
