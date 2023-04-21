import 'package:flutter/material.dart';

final List<String> prices = [
  "0",
  "700",
  "1000",
  "1300",
  "1500",
  "1800",
  "2000",
  "1000"
];

void buyLevDialog(BuildContext context, bool darkMode, int selHsk) {
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
                    height: 225,
                    width: 275,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Row(children: <Widget>[
                            Image.asset("assets/images/home/hskch/$selHsk.png",
                                width: 140, height: 140),
                            const Spacer(flex: 1),
                            DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green),
                                child: Text(
                                  "Rs. " + prices[selHsk],
                                )),
                            const Spacer(flex: 1),
                          ]),
                          Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  elevation: 5,
                                  color: darkMode == true
                                      ? Colors.grey[900]
                                      : Colors.lightBlue[800],
                                  child: SizedBox(
                                      height: 50,
                                      width: 240,
                                      child: Theme(
                                          data: ThemeData(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: InkWell(
                                              onTap: () => {print("a")},
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: const Text("خریدیں",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  textAlign:
                                                      TextAlign.center))))))
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
