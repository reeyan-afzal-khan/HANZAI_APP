import 'package:flutter/material.dart';

void progressDialog(
    BuildContext context, bool darkMode, int _missCards, int _checkCards) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.transparent,
            child: Center(
                child: Container(
                    height: (MediaQuery.of(context).size.height / 2) + 100,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                              child: Text(
                                "رپورٹ کارڈ",
                                textDirection: TextDirection.rtl,
                              )),
                          Divider(
                              color: darkMode == true
                                  ? Colors.white
                                  : Colors.blueGrey[200]),
                          Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Spacer(flex: 1),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.pinkAccent),
                                        child: Text(
                                          _missCards.toString(),
                                          textDirection: TextDirection.rtl,
                                        )),
                                    const Spacer(flex: 1),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey),
                                        child: Text(
                                          "کریکٹرز جو نہیں یاد: ",
                                          textDirection: TextDirection.rtl,
                                        )),
                                  ])),
                          Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Spacer(flex: 1),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.lightGreen),
                                        child: Text(
                                          _checkCards.toString(),
                                          textDirection: TextDirection.rtl,
                                        )),
                                    const Spacer(flex: 1),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey),
                                        child: Text(
                                          "کریکٹرز جو یاد ہے: ",
                                          textDirection: TextDirection.rtl,
                                        )),
                                  ])),
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                        child: Text(
                                          (_missCards + _checkCards).toString(),
                                          textDirection: TextDirection.rtl,
                                        )),
                                    DefaultTextStyle(
                                        style: TextStyle(
                                            fontFamily: "nastaliq_urdu",
                                            fontSize: 29,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        child: Text(
                                          "کُل کریکٹرز: ",
                                          textDirection: TextDirection.rtl,
                                        )),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                  ])),
                          Divider(
                              color: darkMode == true
                                  ? Colors.white
                                  : Colors.blueGrey[200]),
                        ]))))),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
