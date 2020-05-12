import 'package:flutter/material.dart';

import 'game.dart';
import 'grid_widget.dart' as grid_widget;

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
    game.restart();

    widget.server.onGetMove(_getMoveCallback);
  }

  void _getMoveCallback(int row, int col) {
    game.updateGrid(row, col, context);

    setState(() {});
  }

  void _onSquareTap(int row, int col, BuildContext context) {
    game.updateGrid(row, col, context);

    widget.server.sendMove(row, col);
    
    setState(() {});

    //if(game.isGameOver()) {
    //  dialog.showGameOverDialog(context, _initializeState, _getGameOverText());
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("hi"),
        //_createCurrentPlayerText(context),
        grid_widget.createGridWidget(context, game, _onSquareTap),
        Row(children: [Text("hi")]),
        //_createButtons(context),
      ],
    );
  }
}
