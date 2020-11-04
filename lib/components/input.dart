import 'package:flutter/material.dart';

Widget InputAuth(Icon icon, String hint, TextEditingController controller,
    bool obsecure, Color color, TextInputType typeText, bool autofocus) {
  return Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    child: TextField(
      autofocus: autofocus ?? false,
      controller: controller,
      obscureText: obsecure,
      style: TextStyle(
        fontSize: 15,
      ),
      keyboardType: typeText,
      decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: color,
              width: 3,
            ),
          ),
          prefixIcon: Padding(
            child: IconTheme(
              data: IconThemeData(color: color),
              child: icon,
            ),
            padding: EdgeInsets.only(left: 30, right: 10),
          )),
    ),
  );
}
