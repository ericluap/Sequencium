import 'package:flutter/material.dart';

import 'server.dart';
import 'local_game.dart';
import 'online_game.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequencium',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
  Server server = Server();

  bool isMultiplayer = false;

  @override
  void dispose() {
    super.dispose();
    server.dispose();
  }

  void _startMultiplayer() {
    setState(() {
      isMultiplayer = true;
    });
  }

  void _stopMultiplayer() {
    setState(() {
      isMultiplayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentGameUI = isMultiplayer ? 
      OnlineGame(server, _stopMultiplayer) : LocalGame(server, _startMultiplayer);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: currentGameUI,
    );
  }
}
