import 'package:flutter/material.dart';
import 'package:hanzai_app/functions/hsk_colour.dart';
import 'package:hanzai_app/model/card_model.dart';

void levDialog(
    BuildContext context, CardData currCard, int tCards, bool darkModeEnabled) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.9),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: SizedBox(
            height: (MediaQuery.of(context).size.height / 2) + 135,
            width: MediaQuery.of(context).size.width - 20,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tCards,
                itemBuilder: (_, int index) {
                  return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          "  حرف نمبر (${index + 1})",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                          textDirection: TextDirection.ltr,
                        ),
                        trailing: Text(
                          currCard.getHanSimp(),
                          style: TextStyle(
                              fontFamily: 'kaiti',
                              fontSize: 44,
                              color: hskColour(
                                  currCard.getHskLev(), darkModeEnabled)),
                        ),
                        subtitle: Text(
                          " اس حرف کی فریکوئنسی (${currCard.getComFreq() + 1})",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey),
                          textDirection: TextDirection.ltr,
                        ),
                      ));
                })),
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
