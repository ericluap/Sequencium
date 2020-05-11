import 'package:flutter/material.dart';

void showGameOverDialog(BuildContext context, restart, gameOverText) {
  Widget restartButton= FlatButton(
    child: Text("Restart"),
    onPressed: () {
      restart();
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Game Over"),
    content: Text(gameOverText),
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

void showRestartDialog(BuildContext context, restart) {
  Widget restartButton = FlatButton(
    child: Text("Restart"),
    onPressed: () {
      restart();
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



