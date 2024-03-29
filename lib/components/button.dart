import 'package:flutter/material.dart';

Widget ButtonAuth(String text, Color splashColor, Color highlightColor,
    Color fillColor, Color textColor, void function()) {
  bool clicked = false;
  return RaisedButton(
    highlightElevation: 0.0,
    splashColor: splashColor,
    highlightColor: highlightColor,
    elevation: 10.0,
    color: fillColor,
    shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    child: Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
    ),
    onPressed: () {
      if (!clicked) {
        clicked = true;
        function();
      } else {
        return null;
      }
    },
  );
}
