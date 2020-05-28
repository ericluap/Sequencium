import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as statusCodes;

class Server {
  WebSocketChannel channel;

  final url = 'wss://sequencium-server.herokuapp.com/';
  //final url = 'ws://127.0.0.1:8080';

  bool isConnected = false;

  var subscription;

  bool hasJoinCode = false;
  String joinCode = "";

  bool hasColor = false;
  String color = "";

  Function joinCodeCallback = (String joinCode) {};
  Function getMoveCallback = (int row, int col) {};
  Function opponentDisconnectCallback = () {};
  Function opponentJoinCallback = (String color) {};

  void resetState() {
    hasJoinCode = false;
    joinCode = "";
    isConnected = false;

    hasColor = false;
    color = "";

    joinCodeCallback = (String joinCode) {};
    getMoveCallback = (int row, int col) {};
    opponentDisconnectCallback = () {};
    opponentJoinCallback = (String color) {};
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
    _connectToServerIfNeeded();
    joinCodeCallback = callback;
    channel.sink.add("host");
  }

  void joinGame(code) {
    _connectToServerIfNeeded();
    
    hasJoinCode = true;
    joinCode = code;

    channel.sink.add("join " + code);
  }

  void sendMove(int row, int col) {
    _connectToServerIfNeeded();
    String msg = "move " + row.toString() + " " + col.toString();
    channel.sink.add(msg);
  }

  void onOpponentDisconnect(callback) {
    opponentDisconnectCallback = callback;
  }

  void onOpponentJoin(callback) {
    opponentJoinCallback = callback;
  }

  void removeJoinCodeCallback(callback) {
    if(joinCodeCallback == callback) {
      joinCodeCallback = (String joinCode) {};
    }
  }

  void removeGetMoveCallback(callback) {
    if(getMoveCallback == callback) {
      getMoveCallback = (int row, int col) {};
    }
  }

  void removeOpponentDisconnectCallback(callback) {
    if(opponentDisconnectCallback == callback) {
      opponentDisconnectCallback = () {};
    }
  }

  void removeOpponentJoinCallback(callback) {
    if(opponentJoinCallback == callback) {
      opponentJoinCallback = (String color) {};
    }
  }

  void onGetMove(callback) {
    getMoveCallback = callback;
  }

  void _connectToServerIfNeeded() {
    if(!isConnected) {
      connectToServer();
    }
  }

  void _onMessage(String message) {
    String msgType = message.substring(0, 4);

    switch(msgType) {
      case "host": {
        _onHostMessage(message);
      }
      break;

      case "move": {
        _onMoveMessage(message);
      }
      break;

      case "disc": {
        _onOpponentDisconnect();
      }
      break;

      case "join": {
        _onOpponentJoin(message);
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

  void _onMoveMessage(message) {
    String squareStr = message.substring(5);
    List<String> coordinates = squareStr.split(" ");

    int row = int.parse(coordinates[0]);
    int col = int.parse(coordinates[1]);

    getMoveCallback(row, col);
  }

  void _onOpponentDisconnect() {
    opponentDisconnectCallback();
  }

  void _onOpponentJoin(String message) {
    String color = message.substring(5);

    hasColor = true;
    this.color = color;

    opponentJoinCallback(color);
  }

  void _listenToStream() {
    subscription = channel.stream.listen(
      (message) => {
        _onMessage(message)
      },
      // TODO: Do I want to cancel on error? Should I reset all of the state on error?
      onError: (error) {
        resetState();
      },
      cancelOnError: true,
    );
  }

  void disconnectFromServer() {
    resetState();
    channel.sink.close(/*statusCodes.goingAway*/);
  }

  void dispose() {
    disconnectFromServer();
  }

}
