import 'package:flutter/material.dart';

Widget getHanTChars(int currentCard, bool darkMode) {
  return Positioned(
    bottom: 0.0,
    right: 0.0,
    left: 0.0,
    child: Column(children: <Widget>[
      const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Divider(
            height: 1,
          )),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 1,
          ),
          Text((currentCard + 1).toString(),
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: darkMode == true ? Colors.white : Colors.black)),
          Text("کریکٹر نمبر: ",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: darkMode == true ? Colors.white : Colors.black)),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    ]),
  );
}
