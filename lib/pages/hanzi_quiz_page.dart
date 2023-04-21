import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:invert_colors/invert_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:stroke_order_animator/strokeOrderAnimationController.dart';
import 'package:stroke_order_animator/strokeOrderAnimator.dart';

import '../model/card_model.dart';
import 'package:hanzai_app/functions/theme_check.dart';
import 'package:hanzai_app/widgets/han_char_anim.dart';
import 'package:hanzai_app/widgets/han_meaning.dart';
import 'package:hanzai_app/widgets/han_radical.dart';
import 'package:hanzai_app/widgets/quiz_dialog_progress.dart';

class HanzaiQuiz extends StatefulWidget {
  const HanzaiQuiz(
      {Key? key,
      required this.hskLev,
      required this.startFrom,
      required this.endTo})
      : super(key: key);

  final int hskLev, startFrom, endTo;
  @override
  State<HanzaiQuiz> createState() =>
      // ignore: no_logic_in_create_state
      _HanzaiQuizState(hskLev, startFrom, endTo);
}

class _HanzaiQuizState extends State<HanzaiQuiz> with TickerProviderStateMixin {
  bool _darkModeEnabled = false;

  bool _cardExposed = false;
  bool _cardPinyinTest = false;
  bool _cardWriteTest = false;

  bool _pinyinBtn1 = true,
      _pinyinBtn2 = true,
      _pinyinBtn3 = true,
      _pinyinBtn4 = true;

  bool _cardsFinished = false;

  final List<StrokeOrderAnimationController> _strokeOrderAnimationControllers =
      [];

  final List<CardData> _currCards = [];
  late int _tCards;
  late int _currentCard;

  int _missCards = 0, _checkCards = 0;
  List<CardData> _missCardsList = [];

  int _hanScore = 100;

  List<String> _pinyinOptions = [];

  String _expln = "";

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _playAudio = false;

  late int _hskLev;

  _HanzaiQuizState(hskLev, startFrom, endTo) {
    _tCards = startFrom + endTo;
    _currentCard = startFrom;
    _hskLev = hskLev;
  }

  isNotRep() {
    for (int i = 0; i < allCards.length; i++) {
      if (_hskLev == allCards[i].getHskLev()) {
        _currCards.add(allCards[i]);
      }
    }
    for (int i = 0; i < _currCards.length; i++) {
      _currCards[i].setHanID(_currCards[i].getRadHan());
    }
    _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
    _currCards.shuffle();
  }

  currCardHan() {
    for (int i = 0; i < _currCards.length; i++) {
      _strokeOrderAnimationControllers.add(StrokeOrderAnimationController(
          strokeOrders[_currCards[i].getHanID()], this,
          strokeColor: Colors.black,
          outlineColor: Colors.black,
          brushColor: Colors.blueGrey,
          hintColor: Colors.redAccent, onQuizCompleteCallback: (summary) {
        if (summary.nTotalMistakes <= 3) {
          _cardPinyinTest = false;
          _tCards--;
          _currentCard++;
          _pinyinOptions.clear();
          quizPinyinOptions();
          _hanScore = 100;
          _pinyinBtn1 = true;
          _pinyinBtn2 = true;
          _pinyinBtn3 = true;
          _pinyinBtn4 = true;
          _cardWriteTest = false;
          for (var controller in _strokeOrderAnimationControllers) {
            controller.stopQuiz();
            controller.showFullCharacter();
          }
        } else {
          Fluttertoast.showToast(
              msg: [
                "غلطیاں :${summary.nTotalMistakes} \n\nاس کریکٹر پہ مکمل عبور حاصل کرنے کے لیے آپ کو مزید مشق کی ضرورت ہے"
              ].join(),
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.pinkAccent,
              textColor: Colors.white,
              fontSize: 18.0);

          for (var controller in _strokeOrderAnimationControllers) {
            controller.reset();
            controller.startQuiz();
          }
          _hanScore -= 10;
        }
      }));
    }

    for (var controller in _strokeOrderAnimationControllers) {
      controller.showFullCharacter();
    }
  }

  currCardMeaning() async {
    String response = await rootBundle.loadString(
        "assets/data/expln/${_currCards[_currentCard].getHanID() + 1}.txt");
    setState(() {
      _expln = response;
    });
  }

  quizPinyinOptions() {
    Random random = new Random();

    _pinyinOptions.add(_currCards[_currentCard].getPinyin());
    _pinyinOptions
        .add(_currCards[random.nextInt(_currCards.length)].getPinyin());
    _pinyinOptions
        .add(_currCards[random.nextInt(_currCards.length)].getPinyin());
    _pinyinOptions
        .add(_currCards[random.nextInt(_currCards.length)].getPinyin());

    _pinyinOptions.shuffle();
  }

  @override
  void initState() {
    super.initState();
    isNotRep();
    currCardHan();
    currCardMeaning();
    quizPinyinOptions();
  }

  @override
  void dispose() {
    for (var controller in _strokeOrderAnimationControllers) {
      controller.dispose();
    }
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
                value: _strokeOrderAnimationControllers[_currentCard],
                child: Consumer<StrokeOrderAnimationController>(
                    builder: (context, controller, child) {
                  return Stack(children: <Widget>[
                    Visibility(
                        visible: _cardExposed,
                        child: Positioned(
                            bottom: (height / 2) - 55,
                            right: 0.0,
                            left: 0.0,
                            child: getHanCharAnim(
                                height, width, _darkModeEnabled, controller))),
                    AnimatedSize(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.bounceOut,
                        child: SizedBox(
                            height: _cardExposed == false
                                ? (height / 2) + 200
                                : (height / 2) - 80,
                            width: width,
                            child: FittedBox(
                              child: _darkModeEnabled == true
                                  ? InvertColors(
                                      child: StrokeOrderAnimator(
                                          (_strokeOrderAnimationControllers[
                                              _currentCard])),
                                    )
                                  : StrokeOrderAnimator(
                                      (_strokeOrderAnimationControllers[
                                          _currentCard])),
                            ))),
                    Visibility(
                        visible: _cardExposed,
                        child: Positioned(
                            bottom: (height / 2) - 5,
                            right: 0.0,
                            left: 0.0,
                            child: Column(children: <Widget>[
                              const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Divider(height: 10)),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Row(children: <Widget>[
                                    Text(_currCards[_currentCard].getHanSimp(),
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontFamily: "simsun",
                                            color: _darkModeEnabled == true
                                                ? Colors.white
                                                : Colors.black)),
                                    const Spacer(flex: 1),
                                    Text(_currCards[_currentCard].getPinyin(),
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
                                                  "assets/audios/hanzi/char_f/${_currCards[_currentCard].getSound()}.mp3"));

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
                                  ]))
                            ]))),
                    Visibility(
                        visible: _cardExposed,
                        child: Positioned(
                            bottom: (height / 2) - 107,
                            right: 0.0,
                            left: 0.0,
                            child: getHanRadical(
                                height,
                                _currCards[_currentCard].getHanStrokes(),
                                _currCards[_currentCard].getHanRad()))),
                    Visibility(
                        visible: _cardExposed,
                        child: Positioned(
                            bottom: (height / 4) - 202,
                            right: 0.0,
                            left: 0.0,
                            child: SizedBox(
                                height: (height / 2) - 95,
                                child: getHanMeaning(
                                    height, _expln, _darkModeEnabled)))),
                    Visibility(
                      visible: _cardPinyinTest && _cardWriteTest == false,
                      child: Positioned(
                          bottom: (height / 4) - 150,
                          right: 0,
                          left: 0,
                          child: Column(children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                        height: 55,
                                        width: 155,
                                        child: Theme(
                                            data: ThemeData(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                            ),
                                            child: ButtonTheme(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: MaterialButton(
                                                onPressed: () =>
                                                    _pinyinBtn1 == true
                                                        ? pinyinOptionSelected(
                                                            _pinyinOptions[0],
                                                            1,
                                                            controller)
                                                        : Null,
                                                elevation: 2.0,
                                                color: _darkModeEnabled == true
                                                    ? Colors.white24
                                                    : Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  _pinyinBtn1 == true
                                                      ? _pinyinOptions[0]
                                                      : " X ",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: _pinyinBtn1 == true
                                                        ? Colors.white
                                                        : Colors.redAccent,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            )))),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                        height: 55,
                                        width: 155,
                                        child: Theme(
                                            data: ThemeData(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                            ),
                                            child: ButtonTheme(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: MaterialButton(
                                                onPressed: () =>
                                                    _pinyinBtn2 == true
                                                        ? pinyinOptionSelected(
                                                            _pinyinOptions[1],
                                                            2,
                                                            controller)
                                                        : Null,
                                                elevation: 2.0,
                                                color: _darkModeEnabled == true
                                                    ? Colors.white24
                                                    : Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  _pinyinBtn2 == true
                                                      ? _pinyinOptions[1]
                                                      : " X ",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: _pinyinBtn2 == true
                                                        ? Colors.white
                                                        : Colors.redAccent,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ))))
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                        height: 55,
                                        width: 155,
                                        child: Theme(
                                            data: ThemeData(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                            ),
                                            child: ButtonTheme(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: MaterialButton(
                                                onPressed: () =>
                                                    _pinyinBtn3 == true
                                                        ? pinyinOptionSelected(
                                                            _pinyinOptions[2],
                                                            3,
                                                            controller)
                                                        : Null,
                                                elevation: 2.0,
                                                color: _darkModeEnabled == true
                                                    ? Colors.white24
                                                    : Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  _pinyinBtn3 == true
                                                      ? _pinyinOptions[2]
                                                      : " X ",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: _pinyinBtn3 == true
                                                        ? Colors.white
                                                        : Colors.redAccent,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            )))),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                        height: 55,
                                        width: 155,
                                        child: Theme(
                                            data: ThemeData(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                            ),
                                            child: ButtonTheme(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: MaterialButton(
                                                onPressed: () =>
                                                    _pinyinBtn4 == true
                                                        ? pinyinOptionSelected(
                                                            _pinyinOptions[3],
                                                            4,
                                                            controller)
                                                        : Null,
                                                elevation: 2.0,
                                                color: _darkModeEnabled == true
                                                    ? Colors.white24
                                                    : Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  _pinyinBtn4 == true
                                                      ? _pinyinOptions[3]
                                                      : " X ",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: _pinyinBtn4 == true
                                                        ? Colors.white
                                                        : Colors.redAccent,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ))))
                              ],
                            )
                          ])),
                    ),
                    Visibility(
                        visible: _cardPinyinTest == false && _cardWriteTest,
                        child: Positioned(
                          bottom: (height / 4) - 120,
                          right: 0,
                          left: 0,
                          child: Text(
                            "اب اس حرف کو لکھنے کی کوشش کیجیے",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w200,
                                color: _darkModeEnabled == true
                                    ? Colors.white
                                    : Colors.black),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Visibility(
                                    visible:
                                        !_cardPinyinTest && !_cardWriteTest,
                                    child: SizedBox(
                                      width: width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Visibility(
                                              visible: _cardsFinished == false
                                                  ? true
                                                  : false,
                                              child: AnimatedSize(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeIn,
                                                child: Container(
                                                  height: 60,
                                                  width: (_cardExposed == false
                                                      ? 170
                                                      : 300),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 5,
                                                          bottom: 10),
                                                  child: Theme(
                                                    data: ThemeData(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                    ),
                                                    child: ButtonTheme(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: MaterialButton(
                                                        onPressed: () =>
                                                            userAnsBtnClicked(
                                                                true, false),
                                                        elevation: 2.0,
                                                        color:
                                                            _darkModeEnabled ==
                                                                    true
                                                                ? Colors.white24
                                                                : Colors
                                                                    .black87,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        child: Text(
                                                          _cardsFinished != true
                                                              ? (!_cardExposed
                                                                  ? "نہیں یاد"
                                                                  : "دوسرا  کریکٹر")
                                                              : "ختم ہو گئے",
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: !_cardExposed
                                                                ? Colors
                                                                    .redAccent
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          AnimatedOpacity(
                                            opacity: _cardsFinished == false
                                                ? _cardExposed
                                                    ? 0.0
                                                    : 1.0
                                                : 1.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn,
                                              child: Visibility(
                                                visible: _cardsFinished == false
                                                    ? _cardExposed != true
                                                        ? true
                                                        : false
                                                    : true,
                                                child: Container(
                                                  height: 60,
                                                  width: _cardsFinished == false
                                                      ? 170
                                                      : 300,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Theme(
                                                    data: ThemeData(
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent),
                                                    child: ButtonTheme(
                                                      child: MaterialButton(
                                                        onPressed: () =>
                                                            userAnsBtnClicked(
                                                                false, true),
                                                        elevation: 2.0,
                                                        color:
                                                            _darkModeEnabled ==
                                                                    true
                                                                ? Colors.white24
                                                                : Colors
                                                                    .black87,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        child: Text(
                                                          !_cardsFinished
                                                              ? "یاد ہے"
                                                              : "پروگسر",
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: !_cardsFinished
                                                                ? Colors
                                                                    .lightGreen
                                                                : Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Visibility(
                                    visible: !_cardExposed &&
                                        (_cardPinyinTest && _cardWriteTest),
                                    child: Column(children: <Widget>[
                                      Divider(
                                          height: 5,
                                          color: _darkModeEnabled == true
                                              ? Colors.white54
                                              : Colors.black54),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Spacer(
                                            flex: 1,
                                          ),
                                          Text(_tCards.toString(),
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      _darkModeEnabled == true
                                                          ? Colors.white
                                                          : Colors.black)),
                                          Text("باقی کریکٹرز: ",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color:
                                                      _darkModeEnabled == true
                                                          ? Colors.white
                                                          : Colors.black)),
                                          const Spacer(
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ])),
                                Visibility(
                                    visible: _cardPinyinTest || _cardWriteTest,
                                    child: Column(children: <Widget>[
                                      Divider(
                                          height: 5,
                                          color: _darkModeEnabled == true
                                              ? Colors.white54
                                              : Colors.black54),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Spacer(
                                            flex: 1,
                                          ),
                                          Text(_hanScore.toString(),
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                  color: _hanScore > 60
                                                      ? _darkModeEnabled == true
                                                          ? Colors.white
                                                          : Colors.black
                                                      : Colors.redAccent)),
                                          Text("اس حرف کا کُل سکور: ",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color:
                                                      _darkModeEnabled == true
                                                          ? Colors.white
                                                          : Colors.black)),
                                          const Spacer(
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ]))
                              ]),
                        )),
                  ]);
                }))));
  }

  void userAnsBtnClicked(bool repBtnClk, bool avdBtnClk) {
    setState(() {
      if (!_cardExposed && _tCards > 0 && !repBtnClk) {
        if (_currentCard == _currCards.length) {
          _cardsFinished = true;
        }
        _cardPinyinTest = true;
      }

      if (_cardExposed == false && repBtnClk) {
        _cardExposed = true;
        _tCards--;
        currCardMeaning();
        _pinyinOptions.clear();
        quizPinyinOptions();
        _missCardsList.add(_currCards[_currentCard]);
        _missCards++;
      } else if (!avdBtnClk) {
        _currentCard++;
        _pinyinOptions.clear();
        quizPinyinOptions();
        if (_tCards != 0) {
          _cardExposed = false;
        }
        _expln = "";
      }

      if (_tCards == 0) {
        _cardsFinished = true;
      }

      if (_tCards == 0 && avdBtnClk) {
        progressDialog(context, _darkModeEnabled, _missCards, _checkCards);
      }
    });
  }

  void pinyinOptionSelected(String pinyinText, int pinyinBtn,
      StrokeOrderAnimationController controller) {
    setState(() {
      if (pinyinText == _currCards[_currentCard].getPinyin()) {
        assetsAudioPlayer.open(Audio(
            "assets/audios/hanzi/char_f/${_currCards[_currentCard].getSound()}.mp3"));
        if (pinyinBtn == 1) {
          _pinyinBtn2 = false;
          _pinyinBtn3 = false;
          _pinyinBtn4 = false;
        } else if (pinyinBtn == 2) {
          _pinyinBtn1 = false;
          _pinyinBtn3 = false;
          _pinyinBtn4 = false;
        } else if (pinyinBtn == 3) {
          _pinyinBtn1 = false;
          _pinyinBtn2 = false;
          _pinyinBtn4 = false;
        } else {
          _pinyinBtn1 = false;
          _pinyinBtn2 = false;
          _pinyinBtn3 = false;
        }
        _cardPinyinTest = false;
        _cardWriteTest = true;

        controller.startQuiz();
      } else {
        if (pinyinBtn == 1)
          _pinyinBtn1 = false;
        else if (pinyinBtn == 2)
          _pinyinBtn2 = false;
        else if (pinyinBtn == 3)
          _pinyinBtn3 = false;
        else if (pinyinBtn == 4) _pinyinBtn4 = false;

        Fluttertoast.showToast(
          msg: ["-10 points"].join(),
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 20.0,
        );

        _hanScore -= 10;
      }
    });
  }
}
