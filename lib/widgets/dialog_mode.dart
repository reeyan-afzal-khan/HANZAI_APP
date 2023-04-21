import 'package:flutter/material.dart';

void modeDialog(BuildContext context, String modeDetail, int idx) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.9),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.transparent,
            child: Center(
                child: Container(
                    height: (MediaQuery.of(context).size.height / 2) + 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Image.asset("assets/images/home/$idx.jpg"),
                          const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: DefaultTextStyle(
                                  style: TextStyle(
                                      fontFamily: "nastaliq_urdu",
                                      fontSize: 24,
                                      color: Colors.black),
                                  child: Text(
                                    "تفصیلات کے لیے نیچے سکرول کریں",
                                  ))),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: DefaultTextStyle(
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  child: Text(
                                    modeDetail,
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                  )))
                        ])))))),
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
