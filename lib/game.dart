import 'dart:math';

import 'package:flutter/material.dart';

import 'player.dart';
import 'square.dart';

class Game {
  // The number of rows and columns (it's a square)
  int size = 6;

  Player currentPlayer;

  // Used to figure out when a turn should be skipped
  // and when the game is over
  int availableSquaresForA;
  int availableSquaresForB;

  // Keep track of the highest number each player has reached
  // Used to figure out who won at the end
  int highestContentForA;
  int highestContentForB;

  List<List<Square>> grid; 

  void restart() {
    _initializeGrid();
    _initializePlayers();
  }

  void _initializeGrid() {
    grid = List.generate(size, (i) {
      return List.generate(size, (j) {
        return Square();
      });
    });
  }

  // Places the 1 in each corner
  void _initializePlayers() {
    currentPlayer = Player.A;
    availableSquaresForA = 0;
    highestContentForA = 1;
    _setSquare(0, 0, Player.A, content : 1);
    _updateAvailableSquares(_getNeighborSquares(0, 0));
    
    currentPlayer = Player.B;
    availableSquaresForB = 0;
    highestContentForB = 1;
    _setSquare(size-1, size-1, Player.B, content : 1);
    _updateAvailableSquares(_getNeighborSquares(size-1, size-1));

    currentPlayer = Player.A;
  }

  // Takes what square was clicked on
  // and updates everything accordingly
  void updateGrid(row, col, BuildContext context) {
    List<Square> allNeighbors = _getNeighborSquares(row, col); 
    var filledNeighbors = allNeighbors.where((n) => !n.isEmpty);
    var sameTeamNeighbors = filledNeighbors.where((n) => n.player == currentPlayer);
    
    if(sameTeamNeighbors.length > 0) {
      int largestNeighbor = sameTeamNeighbors.map((n) => n.content).reduce(max);
      
      int content = largestNeighbor + 1;

      _setSquare(row, col, currentPlayer, content : content);

      _updateHighestContent(content);

      _updateAvailableSquares(allNeighbors);

      _updateCurrentPlayer();
    }
  }

  // Sets isAvailable to true for certain squares
  // Increases availableSquaresForA/B
  void _updateAvailableSquares(List<Square> neighbors) {
    var emptyNeighbors = neighbors.where((n) => n.isEmpty);
    var makeAvailable = emptyNeighbors.where((n) => !n.isAvailable(currentPlayer));
    int makeAvailableLength = makeAvailable.length;
    makeAvailable.forEach((n) => n.makeAvailable(currentPlayer));
    
    switch(currentPlayer) {
      case Player.A: {
        availableSquaresForA += makeAvailableLength;
      }
      break;

      case Player.B: {
        availableSquaresForB += makeAvailableLength;
      }
      break;
    }
  }

  void _updateHighestContent(int content) {
    switch(currentPlayer) {
      case Player.A: {
        highestContentForA = max(content, highestContentForA);
      }
      break;

      case Player.B: {
        highestContentForB = max(content, highestContentForB);
      }
      break;
    }
  }

  // If there are no squares left a player
  // it skips their turn
  void _updateCurrentPlayer() {
    switch(currentPlayer) {
      case Player.A: {
        if(availableSquaresForB > 0) {
          currentPlayer = Player.B;
        }
        else {
          currentPlayer = Player.A;
        }
      }
      break;

      case Player.B: {
        if(availableSquaresForA > 0) {
          currentPlayer = Player.A;
        }
        else {
          currentPlayer = Player.B;
        }
      }
      break;
    }
  }
 
  bool isGameOver() {
    return (availableSquaresForA == 0 && availableSquaresForB == 0);
  }

  bool isSquareAvailable(row, column) {
    return grid[row][column].isAvailable(currentPlayer);
  }


  List<Square> _getNeighborSquares(row, col) {
    List<Square> neighbors = List(); 

    if(row > 0) {
      // Top
      neighbors.add(grid[row-1][col]);
    }
    if(col > 0) {
      // Left
      neighbors.add(grid[row][col-1]);
    }
    if(row < size-1) {
      // Bottom
      neighbors.add(grid[row+1][col]);
    }
    if(col < size-1) {
      // Right
      neighbors.add(grid[row][col+1]);
    }
    if(row > 0 && col > 0) {
      // Top-left
      neighbors.add(grid[row-1][col-1]);
    }
    if(row < size-1 && col > 0) {
      // Bottom-left
      neighbors.add(grid[row+1][col-1]);
    }
    if(row > 0 && col < size-1) {
      // Top-right
      neighbors.add(grid[row-1][col+1]);
    }
    if(row < size-1 && col < size-1) {
      // Bottom-right
      neighbors.add(grid[row+1][col+1]);
    }

    return neighbors;
  }

  // Places the number in the square
  // Decreases availableSquaresForA/B
  void _setSquare(int row, int col, Player player, {int content}) {
    Square square = grid[row][col];
    square.player = player;
    square.content = content;
    square.isEmpty = false;

    if(square.isAvailableForA) {
      availableSquaresForA--;
    }
    if(square.isAvailableForB) {
      availableSquaresForB--;
    }

    square.isAvailableForA = false;
    square.isAvailableForB = false;
  }
}



