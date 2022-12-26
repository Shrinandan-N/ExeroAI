import 'package:flutter/material.dart';

Widget LargeButton(String title, Color color, Color txtColor, bool isClear,
    BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 3 / 4,
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(65),
        color: color,
        border: isClear ? Border.all(width: 2.0, color: Colors.white) : null),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
            color: txtColor, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
