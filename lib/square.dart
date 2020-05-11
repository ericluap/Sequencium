import 'player.dart';

class Square {
  Square({
    this.isEmpty = true, this.content = 0, this.player, 
    this.isAvailableForA = false, this.isAvailableForB = false
  });

  bool isEmpty;
  int content;
  Player player;
  bool isAvailableForA;
  bool isAvailableForB;

  void makeAvailable(Player currentPlayer) {
    switch(currentPlayer) {
      case Player.A: {
        isAvailableForA = true;
      }
      break;

      case Player.B: {
        isAvailableForB = true;
      }
      break;
    }
  }

  bool isAvailable(Player currentPlayer) {
    switch(currentPlayer) {
      case Player.A: {
        return isAvailableForA;
      }
      break;

      case Player.B: {
        return isAvailableForB;
      }
      break;
    }

    return false;
  }
}
