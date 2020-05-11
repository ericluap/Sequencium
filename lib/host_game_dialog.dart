import 'package:flutter/material.dart';

void showHostGameDialog(BuildContext context, stream) {
  AlertDialog alert = AlertDialog(
    title: Text("Host Game"),
    content: HostGameCode(stream),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

class HostGameCode extends StatefulWidget {
  HostGameCode(this.stream);

  final stream;

  @override
  _HostGameCodeState createState() => _HostGameCodeState();
}

class _HostGameCodeState extends State<HostGameCode> {
  final controller = TextEditingController();
  var joinCode;

  @override
  void initState() {
    widget.stream.listen((cmd) => {
      if(_isHostCmd(cmd)) {
        setState(() {
          joinCode = _getCodeFromCmd(cmd);
        })
      }
    });
  }

        
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _isHostCmd(String cmd) {
    return cmd.substring(0, 4) == "host";
  }

  _getCodeFromCmd(String cmd) {
    return cmd.substring(5);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (BuildContext context, snapshot) {
        if(joinCode != null || (snapshot.hasData && _isHostCmd(snapshot.data))) {
          controller.text = _getCodeFromCmd(snapshot.data);

          Widget code = Expanded(child: TextField(
            textAlign: TextAlign.center,
            autofocus: true,
            controller: controller,
            readOnly: true,
          ));

          Widget label = Text("Join Code: ");

          return Row(
            children: <Widget>[
              label,
              code,
            ]
          );
        }
        else {
          return Text("Waiting for code...");
        }
      }
    );
  }
}


