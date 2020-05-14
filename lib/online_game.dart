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

  @override
  void initState() {
    _initializeState();

    widget.server.onGetMove(_getMoveCallback);
  }

  void _initializeState() {
    game.restart();
    setState(() {});
  }

  @override
  void dispose() {
    widget.server.removeGetMoveCallback(_getMoveCallback);
    super.dispose();
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
        Text("hi"),
        //_createCurrentPlayerText(context),
        grid_widget.createGridWidget(game, _onSquareTap),
        _createButtons(),
      ],
    );
  }
}
