import 'package:flutter/material.dart';

import 'game.dart';
import 'grid_widget.dart' as grid_widget;
import 'dialog.dart' as dialog;

class OnlineGame extends StatefulWidget {
  OnlineGame(this.server, this.stopMultiplayer);

  final server;
  final Function stopMultiplayer;

  @override
  _OnlineGameState createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  Game game = Game();

  String text;

  String player;

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
    text = "Waiting for opponent...";
  }

  void _resetPlayer() {
  }

  @override
  void dispose() {
    widget.server.disconnectFromServer();
    super.dispose();
  }

  void _opponentJoinCallback(String color) {
    text = "You are " + color;
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

  Widget _createButtons() {
    Widget disconnect = RaisedButton(
      child: Text("Disconnect"),
      onPressed: () {
        dialog.showDisconnectDialog(context, _disconnect);
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        disconnect,
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(text),
        //_createCurrentPlayerText(context),
        grid_widget.createGridWidget(game, _onSquareTap),
        _createButtons(),
      ],
    );
  }
}
