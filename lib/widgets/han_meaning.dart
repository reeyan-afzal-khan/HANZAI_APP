import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Widget getHanMeaning(double height, String? expl, bool darkMode) {
  return Html(
    data: expl,
    style: {
      ".urduHeading1": Style(
          margin: Margins.only(top: 25),
          fontSize: FontSize(26.0),
          fontFamily: "nastaliq_urdu",
          direction: TextDirection.rtl,
          color: Colors.redAccent),
      ".urduHeading2": Style(
          margin: Margins.only(top: 25),
          fontSize: FontSize(25.0),
          fontFamily: "nastaliq_urdu",
          direction: TextDirection.rtl,
          color: Colors.lightGreen),
      ".urduBullets": Style(
        margin: Margins.only(bottom: 20),
        fontSize: FontSize(22.0),
        textAlign: TextAlign.right,
        fontFamily: "simsun",
        color: Colors.blueAccent,
        fontWeight: FontWeight.w700,
        direction: TextDirection.rtl,
      ),
      ".urduSentence": Style(
        margin: Margins.only(bottom: 20),
        fontSize: FontSize(20.0),
        textAlign: TextAlign.justify,
        fontFamily: "nastaliq_urdu",
        fontWeight: FontWeight.w500,
        color: darkMode == true ? Colors.white : Colors.black,
        direction: TextDirection.rtl,
      ),
      ".urduExample": Style(
        margin: Margins.only(top: 20),
        fontSize: FontSize(18.0),
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w900,
        color: Colors.blueGrey,
        fontFamily: "nastaliq_urdu",
        direction: TextDirection.rtl,
      ),
      ".chineseSentence": Style(
        margin: Margins.zero,
        textAlign: TextAlign.center,
        fontSize: FontSize(28.0),
        fontWeight: FontWeight.w900,
        fontFamily: "simsun",
        direction: TextDirection.ltr,
      ),
      ".pinyinSentence": Style(
        margin: Margins.only(bottom: 20),
        textAlign: TextAlign.center,
        color: Colors.grey,
        fontSize: FontSize(17),
        fontFamily: "robotoMono",
        direction: TextDirection.ltr,
      )
    },
  );
}
