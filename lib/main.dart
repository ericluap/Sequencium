import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as statusCodes;

import 'dialog.dart' as dialog;
import 'player.dart';
import 'game.dart';
import 'join_game_dialog.dart' as join_game;
import 'host_game_dialog.dart' as host_game;
import 'grid_widget.dart' as grid_widget;

const url = 'ws://localhost:8080';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

class _SequenciumState extends State<Sequencium> {
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(url));
  var stream;

  String hostCode;
  String joinCode;

  Game game = Game();

  @override
  void dispose() {
    super.dispose();
    channel.sink.close(statusCodes.goingAway);
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
    _initializeSocket();
  }

  void _initializeState() {
    game.restart();
    
    setState(() {});
  }

  void _initializeSocket() {
    hostCode = "Waiting for code...";
    joinCode = "Waiting for code...";

    stream = channel.stream.asBroadcastStream();

    stream.listen((message) {
      _onSocketMessage(message);
    });
  }

  void _onSocketMessage(String message) {
    String command = message.substring(0, 4);

    if(command == "host") {
      String code = message.substring(5);

      setState(() {
        hostCode = code;
      });
    }
  }

  void _getHostCode() {
    channel.sink.add("host");
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
      print(code);
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
       onPressed: () {host_game.showHostGameDialog(context, stream);channel.sink.add("host");},
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _createCurrentPlayerText(context),
          grid_widget.createGridWidget(context, game, _onSquareTap),
          _createButtons(context),
        ],
      ),
    );
  }
}
