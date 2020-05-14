import 'package:flutter/material.dart';

void showGameOverDialog(BuildContext context, restart, gameOverText) {
  Widget restartButton= FlatButton(
    child: Text("Restart"),
    onPressed: () {
      Navigator.of(context).pop();
      restart();
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
      Navigator.of(context).pop();
      restart();
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

void showDisconnectDialog(BuildContext context, Function disconnect) {
  Widget disconnectButton = FlatButton(
    child: Text("Disconnect"),
    onPressed: () {
      Navigator.of(context).pop();
      disconnect();
    },
  );

  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Disconnect"),
    content: Text("Are you sure you want to disconnect from the game?"),
    actions: [
      cancelButton,
      disconnectButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}
