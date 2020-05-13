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

  Widget _createButtons() {
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
        Row(children: [Text("hi")]),
        //_createButtons(context),
      ],
    );
  }
}
