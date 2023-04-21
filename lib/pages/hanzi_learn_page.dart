import 'dart:async';

import 'package:flutter/gestures.dart';
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

import '../widgets/han_char_anim.dart';
import '../widgets/han_meaning.dart';
import '../widgets/han_radical.dart';
import '../widgets/han_tchars.dart';

class HanziLearn extends StatefulWidget {
  const HanziLearn(
      {Key? key,
      required this.hskLev,
      required this.hskMode,
      required this.hskOrder,
      required this.startFrom,
      required this.endTo})
      : super(key: key);

  final int hskLev, hskMode, hskOrder, startFrom, endTo;
  @override
  State<HanziLearn> createState() =>
      // ignore: no_logic_in_create_state
      _HanziLearnState(hskLev, hskMode, hskOrder, startFrom, endTo);
}

class _HanziLearnState extends State<HanziLearn> with TickerProviderStateMixin {
  bool _darkModeEnabled = false;

  late PageController _pageController;

  final List<StrokeOrderAnimationController> _strokeOrderAnimationControllers =
      [];

  final List<CardData> _currCards = [];
  final List<CardSortData> _currCardsSortDetails = [];

  late int _startFrom, _endTo;
  late int _currentCard;

  String _expln = "";

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _playAudio = false;

  late int _hskLev, _hskMode, _hskOrder;

  _HanziLearnState(hskLev, hskMode, hskOrder, startFrom, endTo) {
    _startFrom = startFrom;
    _endTo = endTo;
    _currentCard = startFrom;
    _hskLev = hskLev;
    _hskMode = hskMode;
    _hskOrder = _hskMode == 0 ? hskOrder : 0;
  }

  isNotRep() {
    for (int i = 0; i < allCards.length; i++) {
      if (_hskLev == allCards[i].getHskLev()) {
        _currCards.add(allCards[i]);
      }

      if (_hskLev == allCardsLev[i].getHskLev() && _hskOrder == 1) {
        _currCardsSortDetails.add(allCardsLev[i]);
      } else if (_hskLev == allCardsCom[i].getHskLev() && _hskOrder == 2) {
        _currCardsSortDetails.add(allCardsCom[i]);
      }
    }

    if (_hskMode == 1) {
      _currCards.shuffle();
      for (int i = 0; i < _currCards.length; i++) {
        _currCards[i].setHanID(_currCards[i].getRadHan());
      }
    } else {
      if (_hskOrder == 0) {
        for (int i = 0; i < _currCards.length; i++) {
          _currCards[i].setHanID(_currCards[i].getRadHan());
        }
        _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
      } else if (_hskOrder == 1) {
        for (int i = 0; i < _currCards.length; i++) {
          _currCards[i].setHanID(_currCards[i].getLevHan());
        }
        _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
      } else if (_hskOrder == 2) {
        for (int i = 0; i < _currCards.length; i++) {
          _currCards[i].setHanID(_currCards[i].getComFreq());
        }
        _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
      }
    }
  }

  currCardHan() {
    for (int i = 0; i < _currCards.length; i++) {
      _strokeOrderAnimationControllers.add(StrokeOrderAnimationController(
          _hskOrder == 0
              ? strokeOrders[_currCards[i].getHanID()]
              : strokeOrders[_currCardsSortDetails[i].getHanID()],
          this,
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
      }));
    }

    for (var controller in _strokeOrderAnimationControllers) {
      controller.showFullCharacter();
    }
  }

  currCardMeaning() async {
    String response = await rootBundle.loadString(_hskOrder == 0
        ? "assets/data/expln/${_currCards[_currentCard].getHanID() + 1}.txt"
        : "assets/data/expln/${_currCardsSortDetails[_currentCard].getHanID() + 1}.txt");
    setState(() {
      _expln = response;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _startFrom);
    isNotRep();
    currCardHan();
    currCardMeaning();
  }

  @override
  void dispose() {
    for (var controller in _strokeOrderAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  getHanChar(
      double height, double width, StrokeOrderAnimationController controller) {
    return PageView(
      onPageChanged: ((value) => setState(() {
            _currentCard = value;
            controller.showFullCharacter();
            controller.stopQuiz();
            currCardMeaning();
            _playAudio = false;
          })),
      dragStartBehavior: DragStartBehavior.down,
      physics: controller.isQuizzing
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        _endTo + 1,
        (index) => Column(children: <Widget>[
          SizedBox(
              height: (height / 2) - 70,
              width: width,
              child: FittedBox(
                child: _darkModeEnabled == true
                    ? InvertColors(
                        child: StrokeOrderAnimator(
                            (_strokeOrderAnimationControllers[_currentCard])),
                      )
                    : StrokeOrderAnimator(
                        (_strokeOrderAnimationControllers[_currentCard])),
              )),
        ]),
      ),
    );
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
                    Positioned(
                        bottom: height / 20,
                        right: 0.0,
                        left: 0.0,
                        child: SizedBox(
                            height: (height / 2) - 170,
                            child: getHanMeaning(
                                height, _expln, _darkModeEnabled))),
                    Positioned(
                        bottom: height / 3,
                        right: 0.0,
                        left: 0.0,
                        child: getHanRadical(
                            height,
                            _currCards[_currentCard].getHanStrokes(),
                            _currCards[_currentCard].getHanRad())),
                    getHanChar(height, width, controller),
                    Positioned(
                        bottom: (height / 2) - 25,
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
                        ])),
                    Positioned(
                        bottom: (height / 2) - 75,
                        right: 0.0,
                        left: 0.0,
                        child: getHanCharAnim(
                            height, width, _darkModeEnabled, controller)),
                    getHanTChars(_currentCard, _darkModeEnabled)
                  ]);
                }))));
  }
}
