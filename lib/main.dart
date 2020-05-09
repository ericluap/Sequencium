import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequencium',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Sequencium(title: 'Sequencium'),
    );
  }
}

class Sequencium extends StatefulWidget {
  Sequencium({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SequenciumState createState() => _SequenciumState();
}

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

class _SequenciumState extends State<Sequencium> {
  int _counter = 0;

  // The number of rows and columns (it's a square)
  int size = 6;

  List<List<Square>> grid;
  Player currentPlayer;

  int availableSquaresForA;
  int availableSquaresForB;

  int highestContentForA;
  int highestContentForB;

  String strColorForA = "Blue";
  Color colorForA = Colors.blue;

  String strColorForB = "Red";
  Color colorForB = Colors.red;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    _initializeGrid();
    _initializePlayers();
    
    setState(() {});
  }

  void _initializeGrid() {
    grid = List.generate(size, (i) {
			return List.generate(size, (j) {
				return Square();
			});
		});
	}

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

  void _updateGrid(row, col, {BuildContext context=null}) {
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

    if(context != null && _isGameOver()) {
      _showGameOverDialog(context);
    }
  }

  String _getGameOverText() {
    if(highestContentForA == highestContentForB) {
      return "It was a tie!";
    }
    else if(highestContentForA > highestContentForB) {
      return "Player " + strColorForA + " won!";
    }
    else {
      return "Player " + strColorForB + " won!";
    }
  }

  void _showGameOverDialog(BuildContext context) {
    Widget restartButton= FlatButton(
      child: Text("Restart"),
      onPressed: () {
        _initializeState();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Game Over"),
      content: Text(_getGameOverText()),
      actions: [
        restartButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }

  void _showRestartDialog(BuildContext context) {
    Widget restartButton = FlatButton(
      child: Text("Restart"),
      onPressed: () {
        _initializeState();
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Restart Game"),
      content: Text("Are you sure you want to restart the game?"),
      actions: [
        cancelButton,
        restartButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }

  bool _isGameOver() {
    return (availableSquaresForA == 0 && availableSquaresForB == 0);
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

  void _onSquareTap(int row, int col, BuildContext context) {
    _updateGrid(row, col, context: context);
    setState((){});
  }

  String _getGridSquareContent(int row, int col) {
    Square square = grid[row][col];

    if(square.isEmpty) {
      return "";
    }
    else {
      return square.content.toString();
    }
  }

  // The borders on the edges have to be doubled
  // in order to be same thickness as the borders on the inside
  Border _createGridBorder(row, column) {
    double desiredWidth = 2.0;
    BorderSide defaultBorder = BorderSide(color: Colors.black, width: desiredWidth);
    BorderSide left = defaultBorder;
    BorderSide right = defaultBorder;
    BorderSide top = defaultBorder;
    BorderSide bottom = defaultBorder;

    if(row == 0) {
      top = BorderSide(color: Colors.black, width: desiredWidth*2);
    }
    if(column == 0) {
      left = BorderSide(color: Colors.black, width: desiredWidth*2);
    }
    if(row == size-1) {
      bottom = BorderSide(color: Colors.black, width: desiredWidth*2);
    }
    if(column == size-1) {
      right = BorderSide(color: Colors.black, width: desiredWidth*2);
    }

    return Border(left: left, right: right, top: top, bottom: bottom);
  }

  bool _isSquareAvailable(row, column) {
    return grid[row][column].isAvailable(currentPlayer);
  }

  Color _getSquareColor(row, column) {
    switch(grid[row][column].player) {
      case Player.A: {
        return colorForA;
      }
      break;

      case Player.B: {
        return colorForB;
      }
      break;

      default: {
        return Colors.black;
      }
      break;
    }
  }

  List<Widget> _buildWidgetListFromGrid(BuildContext context) {
    List<Widget> widgetList = List(size*size);

    for(int row = 0; row < size; row++) {
      for(int column = 0; column < size; column++) {
        int index = row*size + column;
        widgetList[index] = Container(
          child: InkWell(
            onTap: _isSquareAvailable(row, column) ?
              (){_onSquareTap(row, column, context);} : null,
            child: Center(
              child: Text(
                _getGridSquareContent(row, column),
                style: TextStyle(
                  fontSize: 25.0,
                  color: _getSquareColor(row, column)
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            border: _createGridBorder(row, column),
          ),
        );
      }
    }

             
    return widgetList;
  }

  Widget _createGridWidget(BuildContext context) {
    Widget gridWidget = GridView.count(
      crossAxisCount: size,
      children: _buildWidgetListFromGrid(context),
    );

    var constraints = (childWidget) => ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 540.0,
        maxHeight: 540.0,
      ),
      child: childWidget,
    );

    var padding = (childWidget) => Padding(
      padding: EdgeInsets.all(20.0),
      child: childWidget,
    );

    var center = (childWidget) => Center(
      child: childWidget,
    );

    return center(padding(constraints(gridWidget)));
  }

  Widget _createRestartButtonWidget(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {_showRestartDialog(context);},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _createGridWidget(context),
          _createRestartButtonWidget(context),
        ],
      ),
    );
  }
}
