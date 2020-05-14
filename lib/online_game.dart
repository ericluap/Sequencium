import 'package:flutter/material.dart';

import 'game.dart';
import 'grid_widget.dart' as grid_widget;
import 'dialog.dart' as dialog;
import 'player.dart';
import 'join_code_dialog.dart' as join_code;

class OnlineGame extends StatefulWidget {
  OnlineGame(this.server, this.stopMultiplayer);

  final server;
  final Function stopMultiplayer;

  @override
  _OnlineGameState createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  Game game = Game();

  Player player;
  Color playerColor;
  Color opponentColor;
  bool hasPlayer = false;

  @override
  void initState() {
    _initializeState();

    widget.server.onGetMove(_getMoveCallback);
    widget.server.onOpponentDisconnect(_opponentDisconnectCallback);
    widget.server.onOpponentJoin(_opponentJoinCallback);
  }

  void _initializeState() {
    game.restart();
    _resetText();
    setState(() {});
  }

  void _resetText() {
    hasPlayer = false;
    playerColor = Colors.black;
    opponentColor = Colors.black;
  }

  void _resetPlayer() {
  }

  @override
  void dispose() {
    widget.server.disconnectFromServer();
    super.dispose();
  }

  void _setPlayerFromColor(String color) {
    if(color == grid_widget.strColorForA.toLowerCase()) {
      player = Player.A;
      playerColor = grid_widget.colorForA;
      opponentColor = grid_widget.colorForB;
    }
    else if(color == grid_widget.strColorForB.toLowerCase()) {
      player = Player.B;
      playerColor = grid_widget.colorForB;
      opponentColor = grid_widget.colorForA;
    }
    else {
      // TODO: handle this properly
      player = Player.A;
      playerColor = Colors.black;
      opponentColor = Colors.black;
    }
  }

  void _opponentJoinCallback(String color) {
    hasPlayer = true;
    _setPlayerFromColor(color);
    setState(() {});
  }

  void _opponentDisconnectCallback() {
    _resetText();
    _resetPlayer();
    setState(() {});
  }

  void _getMoveCallback(int row, int col) {
    game.updateGrid(row, col);
      
    setState(() {});
  }

  String _getGameOverText() {
    return "game over";
  }

  bool _isSquareAvailable(Player currentPlayer) {
    if(hasPlayer) {
      return currentPlayer == player;
    }
    else {
      return false;
    }
  }

  void _onSquareTap(int row, int col) {
    game.updateGrid(row, col);

    widget.server.sendMove(row, col);
    
    setState(() {});

    if(game.isGameOver()) {
      dialog.showGameOverDialog(context, _initializeState, _getGameOverText());
    }
  }

  void _disconnect() {
    widget.stopMultiplayer();
  }

  bool _isMyTurn() {
    if(hasPlayer) {
      return game.currentPlayer == player;
    }
    else {
      return false;
    }
  }

  Widget _createButtons() {
    Widget disconnect = RaisedButton(
      child: Text("Disconnect"),
      onPressed: () {
        dialog.showDisconnectDialog(context, _disconnect);
      },
    );

    Widget joinCode = RaisedButton(
      child: Text("Join Code"),
      onPressed: () {
        join_code.showJoinCodeDialog(context, widget.server.joinCode);
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        disconnect,
        joinCode,
      ]
    );
  }

  Widget _createText() {
    Widget text;

    if(!hasPlayer) {
      text = Text(
        "Waiting for opponent...",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
        ),
      );
    }
    else if(_isMyTurn()) {
      text = Text(
        "Your Turn",
        style: TextStyle(
          color: playerColor,
          fontSize: 25.0,
        ),
      );
    }
    else {
      text = Text(
        "Opponent's Turn",
        style: TextStyle(
          color: opponentColor,
          fontSize: 25.0,
        ),
      );
    }

    return text;
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _createText(),
        //_createCurrentPlayerText(context),
        grid_widget.createGridWidget(game, _onSquareTap, _isSquareAvailable),
        _createButtons(),
      ],
    );
  }
}
