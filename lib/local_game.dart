import 'package:flutter/material.dart';

import 'dialog.dart' as dialog;
import 'player.dart';
import 'game.dart';
import 'server.dart';
import 'join_game_dialog.dart' as join_game;
import 'host_game_dialog.dart' as host_game;
import 'grid_widget.dart' as grid_widget;

class LocalGame extends StatefulWidget {
  LocalGame(this.server);

  final server;

  @override
  _LocalGameState createState() => _LocalGameState();
}

class _LocalGameState extends State<LocalGame> {
  Game game = Game();

  @override
  void initState() {
    _initializeState();
  }

  void _initializeState() {
    game.restart();
    
    setState(() {});
  }

  String _getGameOverText() {
    if(game.highestContentForA == game.highestContentForB) {
      return "It was a tie!";
    }
    else if(game.highestContentForA > game.highestContentForB) {
      return "Player " + grid_widget.strColorForA + " won!";
    }
    else {
      return "Player " + grid_widget.strColorForB + " won!";
    }
  }

  String _getCurrentPlayerColorString() {
    switch(game.currentPlayer) {
      case Player.A: {
        return grid_widget.strColorForA;
      }
      break;

      case Player.B: {
        return grid_widget.strColorForB;
      }
      break;
    }

    return "";
  }

  Color _getCurrentPlayerColor() {
    switch(game.currentPlayer) {
      case Player.A: {
        return grid_widget.colorForA;
      }
      break;

      case Player.B: {
        return grid_widget.colorForB;
      }
      break;
    }

    return Colors.black;
  }

  void _onSquareTap(int row, int col, BuildContext context) {
    game.updateGrid(row, col, context);
    
    setState(() {});

    if(game.isGameOver()) {
      dialog.showGameOverDialog(context, _initializeState, _getGameOverText());
    }
  }
  
  Widget _createCurrentPlayerText(BuildContext context) {
    String colorStr = _getCurrentPlayerColorString();

    Widget text = Text(
      colorStr + "'s Turn",
      style: TextStyle(
        fontSize: 25.0,
        color: _getCurrentPlayerColor(),
      ),
    );

    return text;
  }

  Widget _createRestartButton(BuildContext context) {
    var button = IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {dialog.showRestartDialog(context, _initializeState);},
      tooltip: "Restart Game",
    );

    return Flexible(child: button);
  }
  
  Widget _createJoinButton(BuildContext context) {
    void submitCallback(code) {
      widget.server.joinGame(code);
    }

    var joinButton = RaisedButton(
      child: Text("Join Game"),
      onPressed: () {
        join_game.showJoinGameDialog(context, submitCallback);
      },
    );

    return joinButton;
  }

  Widget _createHostButton(BuildContext context) {
    var hostButton = RaisedButton(
      child: Text("Host Game"),
       onPressed: () {
        host_game.showHostGameDialog(context, widget.server, () {print("host game callback fix in local game file");});
      },
    );
    
    return hostButton;
  }

  Widget _createButtons(BuildContext context) {
    var restartButton = _createRestartButton(context);

    var joinButton = _createJoinButton(context);
    var hostButton = _createHostButton(context);

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        restartButton,
        SizedBox(width: 50),
        joinButton,
        hostButton,
      ],
    );

    return row;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _createCurrentPlayerText(context),
        grid_widget.createGridWidget(context, game, _onSquareTap),
        _createButtons(context),
      ],
    );
  }
}