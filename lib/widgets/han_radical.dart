import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

Widget getHanRadical(double height, int strokes, String? radical) {
  return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Html(
                data: strokes != 0
                    ? """<div class='radicalHeading'><p style='margin-top:0px'>کانگسی ریڈیکل<span class='radicalRad'> $radical <span class='strokeHeading'><span class='strokeHeading'>(<span class='strokeNum'>$strokes+ </span> سٹروک)</span></p></div>"""
                    : """<div class='radicalHeading'><p style='margin-top:0px'>کانگسی ریڈیکل<span class='radicalRad'> $radical </span></p></div>""",
                style: {
                  ".radicalHeading": Style(
                      fontSize: FontSize(18.0),
                      fontFamily: "nastaliq_urdu",
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      direction: TextDirection.rtl,
                      textAlign: TextAlign.center),
                  ".radicalRad": Style(
                    fontSize: FontSize(30.0),
                    fontFamily: "simsun",
                    fontWeight: FontWeight.w900,
                    color: Colors.deepOrangeAccent,
                    direction: TextDirection.rtl,
                  ),
                  ".strokeHeading": Style(
                    fontSize: FontSize(18.0),
                    fontFamily: "nastaliq_urdu",
                    fontWeight: FontWeight.w500,
                    direction: TextDirection.rtl,
                  ),
                  ".strokeNum": Style(
                    fontSize: FontSize(18.0),
                    fontFamily: "simsun",
                    fontWeight: FontWeight.w900,
                    direction: TextDirection.rtl,
                  ),
                })),
        const Divider(height: 1),
      ]));
}
