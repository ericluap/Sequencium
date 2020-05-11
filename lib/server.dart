import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as statusCodes;

class Server {
  WebSocketChannel channel;

  final url = 'ws://localhost:8080';

  bool isConnected = false;

  var subscription;

  bool hasJoinCode = false;
  String joinCode = "";
  Function joinCodeCallback = () {};

  void resetState() {
    hasJoinCode = false;
    joinCode = "";
    isConnected = false;
    joinCodeCallback = () {};
  }

  void connectToServer() {
    if(isConnected) {
      return;
    }
    else {
      channel = WebSocketChannel.connect(Uri.parse(url));

      resetState();

      isConnected = true;

      _listenToStream();
    }
  }

  void getJoinCode(callback) {
    joinCodeCallback = callback;
    channel.sink.add("host");
  }

  void _onMessage(String message) {
    String msgType = message.substring(0, 4);

    switch(msgType) {
      case "host": {
        _onHostMessage(message);
      }
      break;

      default: {
      }
      break;
    }
  }
  
  void _onHostMessage(message) {
    hasJoinCode = true;
    joinCode = message.substring(5);

    joinCodeCallback(joinCode);
  }

  void _listenToStream() {
    subscription = channel.stream.listen((message) => {
      _onMessage(message)
    });
  }

  void disconnectFromServer() {
    resetState();
    subscription.cancel();
    channel.sink.close(statusCodes.goingAway);
  }

  void dispose() {
    disconnectFromServer();
  }

}
