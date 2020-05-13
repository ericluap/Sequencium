import 'package:flutter/material.dart';
import 'package:clippy/browser.dart' as clippy;

void showHostGameDialog(BuildContext context, server, multiplayerCallback) {
  AlertDialog alert = AlertDialog(
    title: Text("Host Game"),
    content: HostGameCode(server, multiplayerCallback),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

class HostGameCode extends StatefulWidget {
  HostGameCode(this.server, this.multiplayerCallback);

  final server;
  final multiplayerCallback;

  @override
  _HostGameCodeState createState() => _HostGameCodeState();
}

class _HostGameCodeState extends State<HostGameCode> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = "Waiting for code...";

    if(!widget.server.hasJoinCode) {
      widget.server.getJoinCode(_joinCodeCallback);
    }
    else {
      // This waits until after this widget is built before calling _joinCodeCallback
      // Why do this? Because _joinCodeCallback calls widget.multiplayerCallback
      // and that tries to build OnlineGame
      // but this widget is still building so it causes an exception
      WidgetsBinding.instance.addPostFrameCallback((_) {
        this._joinCodeCallback(widget.server.joinCode);
      });
    }
  }

  @override
  void dispose() {
    widget.server.removeJoinCodeCallback(_joinCodeCallback);
    controller.dispose();
    super.dispose();
  }

  void _joinCodeCallback(String joinCode) {
    controller.text = joinCode;
    setState(() {});

    widget.multiplayerCallback();
  }

  @override
  Widget build(BuildContext context) {

    Widget label = Text("Join Code: ");

    Widget code = Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        autofocus: true,
        controller: controller,
        readOnly: true,
      ),
    );

    Widget copyBtn = Padding(
      child: RaisedButton(
        child: Text("Copy"),
        onPressed: () {
          clippy.write(controller.text);
        },
      ),
      padding: EdgeInsets.only(top: 10.0),
    );

    Widget row = Row(
      children: <Widget>[
        label,
        code,
      ]
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        row,
        copyBtn,
      ],
    );
  }
}


