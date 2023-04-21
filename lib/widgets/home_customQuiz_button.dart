import 'package:flutter/material.dart';

import 'package:hanzai_app/pages/hanzi_learn_page.dart';
import 'package:hanzai_app/pages/hanzi_quiz_page.dart';

Widget getCustomQuizButton(
    BuildContext context,
    bool darkMode,
    int selectedHsk,
    int selectedHskMode,
    int selectedHskOrder,
    int minVal,
    int maxVal,
    int buttonNum) {
  return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 5,
      color: darkMode == true ? Colors.grey[900] : Colors.white,
      child: SizedBox(
          height: 50,
          width: 160,
          child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: InkWell(
                  onTap: () => {
                        if (buttonNum == 1)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HanziLearn(
                                        hskLev: selectedHsk,
                                        hskMode: selectedHskMode,
                                        hskOrder: selectedHskOrder,
                                        startFrom: minVal,
                                        endTo: maxVal)))
                          }
                        else
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HanzaiQuiz(
                                        hskLev: selectedHsk,
                                        startFrom: minVal,
                                        endTo: maxVal))),
                          }
                      },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Text(buttonNum == 1 ? "مشق موڈ" : "ٹیسٹ موڈ",
                      style: TextStyle(
                          fontSize: 30,
                          color: buttonNum == 1
                              ? Colors.lightGreen
                              : Colors.redAccent,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center)))));
}
