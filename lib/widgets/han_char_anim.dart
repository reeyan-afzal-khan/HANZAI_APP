import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';

Widget getHanCharAnim(double height, double width, bool darkMode,
    StrokeOrderAnimationController controller) {
  return Column(children: <Widget>[
    Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 10),
      child: Center(
          child: Row(children: <Widget>[
        const Spacer(flex: 1),
        Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5,
                color: darkMode == true ? Colors.grey[900] : Colors.white,
                child: Container(
                    height: 33,
                    width: (width / 2) - 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (!controller.isQuizzing) {
                          controller.startQuiz();
                        } else {
                          controller.stopQuiz();
                          controller.showFullCharacter();
                        }
                      },
                      child: controller.isQuizzing
                          ? const Text("بس کافی تھا",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700))
                          : Text("خود کوشش کریں",
                              style: TextStyle(
                                  color: darkMode == true
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                    )))),
        const Spacer(flex: 1),
        Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5,
                color: darkMode == true ? Colors.grey[900] : Colors.white,
                child: Container(
                    height: 33,
                    width: (width / 2) - 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: !controller.isQuizzing
                          ? () {
                              if (!controller.isAnimating) {
                                controller.startAnimation();
                              } else {
                                controller.reset();
                                Timer(const Duration(milliseconds: 100),
                                    () => controller.startAnimation());
                              }
                            }
                          : null,
                      child: Text("لکھنے کا طریقہ",
                          style: TextStyle(
                              color: controller.isQuizzing
                                  ? Colors.grey
                                  : controller.isAnimating
                                      ? Colors.redAccent
                                      : darkMode == true
                                          ? Colors.white
                                          : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    )))),
        const Spacer(flex: 1),
      ])),
    ),
  ]);
}
