import 'package:flutter/material.dart';
import 'package:clippy/browser.dart' as clippy;

void showJoinCodeDialog(BuildContext context, String joinCode) {
  AlertDialog alert = AlertDialog(
    title: Text("Join Code"),
    content: JoinGameCode(joinCode),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

class JoinGameCode extends StatefulWidget {
  JoinGameCode(this.joinCode);

  final joinCode;

  @override
  _JoinGameCodeState createState() => _JoinGameCodeState();
}

class _JoinGameCodeState extends State<JoinGameCode> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.joinCode;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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


