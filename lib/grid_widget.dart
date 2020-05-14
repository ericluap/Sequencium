import 'package:flutter/material.dart';

import 'game.dart';
import 'player.dart';
import 'square.dart';

String strColorForA = "Blue";
Color colorForA = Colors.blue;

String strColorForB = "Red";
Color colorForB = Colors.red;

Widget createGridWidget(Game game, tapCallback, isSquareAvailable) {
  Widget gridWidget = GridView.count(
    crossAxisCount: game.size,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: _buildWidgetListFromGrid(game, tapCallback, isSquareAvailable),
  );

  var constraints = (childWidget) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: 540.0,
      maxHeight: 540.0,
    ),
    child: childWidget,
  );

  var padding = (childWidget) => Padding(
    padding: EdgeInsets.all(10.0),
    child: childWidget,
  );

  return padding(constraints(gridWidget));
}

List<Widget> _buildWidgetListFromGrid(Game game, tapCallback, isSquareAvailable) {
  List<Widget> widgetList = List(game.size*game.size);

  for(int row = 0; row < game.size; row++) {
    for(int column = 0; column < game.size; column++) {
      int index = row*game.size + column;

      // If isSquareAvailable make it a FlatButton
      // otherwise make it a Text
      if(game.isSquareAvailable(row, column) && isSquareAvailable(game.currentPlayer)) {
        widgetList[index] = Container(
          child: FlatButton(
            onPressed: () {
              tapCallback(row, column);
            },
            onLongPress: null,
            child: Center(
              child: Text(
                _getGridSquareContent(row, column, game),
                style: TextStyle(
                  fontSize: 25.0,
                  color: _getSquareColor(row, column, game)
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            border: _createGridBorder(row, column, game),
          ),
        );
      }
      else {
        widgetList[index] = Container(
          child: Center(
            child: Text(
              _getGridSquareContent(row, column, game),
              style: TextStyle(
                fontSize: 25.0,
                color: _getSquareColor(row, column, game)
              ),
            ),
          ),
          decoration: BoxDecoration(
            border: _createGridBorder(row, column, game),
          ),
        );
      }
    }
  }

           
  return widgetList;
}

Color _getSquareColor(row, column, game) {
  switch(game.grid[row][column].player) {
    case Player.A: {
      return colorForA;
    }
    break;

    case Player.B: {
      return colorForB;
    }
    break;

    default: {
      return Colors.black;
    }
    break;
  }
}

String _getGridSquareContent(int row, int col, game) {
  Square square = game.grid[row][col];

  if(square.isEmpty) {
    return "";
  }
  else {
    return square.content.toString();
  }
}

// The borders on the edges have to be doubled
// in order to be same thickness as the borders on the inside
Border _createGridBorder(row, column, game) {
  double desiredWidth = 2.0;
  BorderSide defaultBorder = BorderSide(color: Colors.black, width: desiredWidth);
  BorderSide left = defaultBorder;
  BorderSide right = defaultBorder;
  BorderSide top = defaultBorder;
  BorderSide bottom = defaultBorder;

  if(row == 0) {
    top = BorderSide(color: Colors.black, width: desiredWidth*2);
  }
  if(column == 0) {
    left = BorderSide(color: Colors.black, width: desiredWidth*2);
  }
  if(row == game.size-1) {
    bottom = BorderSide(color: Colors.black, width: desiredWidth*2);
  }
  if(column == game.size-1) {
    right = BorderSide(color: Colors.black, width: desiredWidth*2);
  }

  return Border(left: left, right: right, top: top, bottom: bottom);
}
