import 'package:flutter/material.dart';

void showHostGameDialog(BuildContext context, server) {
  AlertDialog alert = AlertDialog(
    title: Text("Host Game"),
    content: HostGameCode(server),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

class HostGameCode extends StatefulWidget {
  HostGameCode(this.server);

  final server;

  @override
  _HostGameCodeState createState() => _HostGameCodeState();
}

class _HostGameCodeState extends State<HostGameCode> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = "Waiting for code...";
    widget.server.getJoinCode(_joinCodeCallback);
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


