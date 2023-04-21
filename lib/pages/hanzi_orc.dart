import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hanzai_app/functions/theme_check.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';

import '../model/card_model.dart';

class HanziLearn extends StatefulWidget {
  const HanziLearn({Key? key, required this.currentCard}) : super(key: key);

  final int currentCard;

  @override
  State<HanziLearn> createState() =>
      // ignore: no_logic_in_create_state
      _HanziLearnState(currentCard);
}

class _HanziLearnState extends State<HanziLearn> with TickerProviderStateMixin {
  late bool _darkModeEnabled;

  late final StrokeOrderAnimationController _strokeOrderAnimationController;
  late final CardData _currCard;

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _playAudio = false;

  String _expln = "";

  late int _currentCard;

  _HanziLearnState(currentCard) {
    _currentCard = currentCard;
  }

  currCardHan() {
    _strokeOrderAnimationController = StrokeOrderAnimationController(
        strokeOrders[_currCard.getRadHan()], this,
        strokeColor: Colors.black,
        outlineColor: Colors.black,
        brushColor: Colors.blueGrey,
        hintColor: Colors.redAccent, onQuizCompleteCallback: (summary) {
      Fluttertoast.showToast(
          msg: [
            summary.nTotalMistakes != 0
                ? " غلطیاں :${summary.nTotalMistakes}"
                : "زبردست! کوئی غلطیاں نہیں تھیں"
          ].join(),
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: summary.nTotalMistakes != 0
              ? Colors.redAccent
              : Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    _strokeOrderAnimationController.showFullCharacter();
  }

  currCardMeaning() async {
    String response = await rootBundle
        .loadString("assets/data/expln/${_currentCard + 1}.txt");

    setState(() {
      _expln = response;
    });
  }

  @override
  void initState() {
    super.initState();
    var index =
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        allCards.indexWhere((CardData) => CardData.getRadHan() == _currentCard);

    if (index != -1) {
      _currCard = allCards[index];
    }

    currCardHan();
    currCardMeaning();
  }

  @override
  void dispose() {
    _strokeOrderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _darkModeEnabled = checkTheme(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return SafeArea(
        child: Scaffold(
            body: ChangeNotifierProvider<StrokeOrderAnimationController>.value(
                value: _strokeOrderAnimationController,
                child: Consumer<StrokeOrderAnimationController>(
                    builder: (context, controller, child) {
                  return Column(children: <Widget>[
                    Expanded(
                        child: SizedBox(
                            height: (height / 2) - 70,
                            width: width,
                            child: FittedBox(
                              child: _darkModeEnabled == true
                                  ? InvertColors(
                                      child: StrokeOrderAnimator(
                                          (_strokeOrderAnimationController)),
                                    )
                                  : StrokeOrderAnimator(
                                      (_strokeOrderAnimationController)),
                            ))),
                    const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(height: 10)),
                    Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Row(children: <Widget>[
                            Text(_currCard.getHanSimp(),
                                style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: "simsun",
                                    color: _darkModeEnabled == true
                                        ? Colors.white
                                        : Colors.black)),
                            const Spacer(flex: 1),
                            Text(_currCard.getPinyin(),
                                style: const TextStyle(fontSize: 40),
                                textAlign: TextAlign.center),
                            const Spacer(flex: 1),
                            Theme(
                                data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    iconTheme: IconThemeData(
                                        color: _darkModeEnabled == true
                                            ? Colors.white70
                                            : Colors.black45)),
                                child: IconButton(
                                  onPressed: () => setState(() {
                                    if (!_playAudio) {
                                      _playAudio = true;
                                      assetsAudioPlayer.open(Audio(
                                          "assets/audios/hanzi/char_f/${_currCard.getSound()}.mp3"));

                                      Timer(
                                          const Duration(seconds: 1),
                                          () => setState(() {
                                                _playAudio = false;
                                              }));
                                    }
                                  }),
                                  icon: Icon(Icons.volume_up,
                                      color: _playAudio == true
                                          ? Colors.redAccent
                                          : Colors.grey),
                                  iconSize: 30,
                                )),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, top: 5, bottom: 10),
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
                                  color: _darkModeEnabled == true
                                      ? Colors.grey[900]
                                      : Colors.white,
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
                                                    fontWeight:
                                                        FontWeight.w700))
                                            : Text("خود کوشش کریں",
                                                style: TextStyle(
                                                    color:
                                                        _darkModeEnabled == true
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      )))),
                          const Spacer(flex: 1),
                          Theme(
                              data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent),
                              child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  elevation: 5,
                                  color: _darkModeEnabled == true
                                      ? Colors.grey[900]
                                      : Colors.white,
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
                                                  Timer(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () => controller
                                                          .startAnimation());
                                                }
                                              }
                                            : null,
                                        child: Text("لکھنے کا طریقہ",
                                            style: TextStyle(
                                                color: controller.isQuizzing
                                                    ? Colors.grey
                                                    : controller.isAnimating
                                                        ? Colors.redAccent
                                                        : _darkModeEnabled ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700)),
                                      )))),
                          const Spacer(flex: 1),
                        ])),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Html(
                                data: _currCard.getHanStrokes() != 0
                                    ? """<div class='radicalHeading'><p style='margin-top:0px'>کانگسی ریڈیکل<span class='radicalRad'> ${_currCard.getHanRad()} <span class='strokeHeading'><span class='strokeHeading'>(<span class='strokeNum'>${_currCard.getHanStrokes()}+ </span> سٹروک)</span></p></div>"""
                                    : """<div class='radicalHeading'><p style='margin-top:0px'>کانگسی ریڈیکل<span class='radicalRad'> ${_currCard.getHanRad()}</span></p></div>""",
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
                        SizedBox(
                          height: (height / 2) - 170,
                          child: Html(
                            data: _expln,
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
                                color: _darkModeEnabled == true
                                    ? Colors.white
                                    : Colors.black,
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
                          ),
                        )
                      ]),
                    ),
                  ]);
                }))));
  }
}
