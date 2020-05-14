import 'package:flutter/material.dart';

void showJoinGameDialog(BuildContext context, submitCallback) {
  AlertDialog alert = AlertDialog(
    title: Text("Join Game"),
    content: JoinGameInput(submitCallback),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

class JoinGameInput extends StatefulWidget {
  JoinGameInput(this.submitCallback);

  var submitCallback;

  @override
  _JoinGameInputState createState() => _JoinGameInputState();
}

class _JoinGameInputState extends State<JoinGameInput> {
  final controller = TextEditingController();
  
  @override
  void initState() {
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: true,
          //onSubmitted: (text) {widget.submitCallback(text);Navigator.of(context).pop();},
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter join code",
          ),
        ),
        RaisedButton(
          child: Text("Join"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.submitCallback(controller.text);
          },
        )
      ]
    );
  }
}
