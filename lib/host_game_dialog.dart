import 'package:flutter/material.dart';

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
      controller.text = widget.server.joinCode;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _joinCodeCallback(String joinCode) {
    setState(() {
      controller.text = joinCode;
    });

    widget.multiplayerCallback();
  }

  @override
  Widget build(BuildContext context) {

    Widget code = Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        autofocus: true,
        controller: controller,
        readOnly: true,
      )
    );

    Widget label = Text("Join Code: ");
          
    return Row(
      children: <Widget>[
        label,
        code,
      ]
    );
  }
}


