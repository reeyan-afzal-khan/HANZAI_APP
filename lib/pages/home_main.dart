import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:another_xlider/another_xlider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

//Model
import 'package:hanzai_app/model/card_model.dart';

//Pages

//Classes
import 'package:hanzai_app/classes/level_status.dart';

//Functions
import 'package:hanzai_app/functions/hsk_colour.dart';
import 'package:hanzai_app/functions/theme_check.dart';

//Widgets
import 'package:hanzai_app/widgets/home_showcase_row.dart';
import 'package:hanzai_app/widgets/dialog_mode.dart';
import 'package:hanzai_app/widgets/dialog_workInProg.dart';
import 'package:hanzai_app/widgets/dialog_buyLev.dart';
import 'package:hanzai_app/widgets/home_customQuiz_button.dart';

GlobalKey<_HomeState> homeKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool _darkModeEnabled = false;

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _playAudio = false;

  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThr = GlobalKey();
  final keyFor = GlobalKey();

  final List<HskLevel> hskLev = [
    HskLevel("HSK 1", 300, true),
    HskLevel("HSK 2", 300, false),
    HskLevel("HSK 3", 300, false),
    HskLevel("HSK 4", 300, false),
    HskLevel("HSK 5", 300, false),
    HskLevel("HSK 6", 300, false),
    HskLevel("HSK 7-9", 1200, false),
    HskLevel("HSK Beyond", 564, false),
  ];

  final List<String> hskSequence = [
    "کانگسی ریڈیکلز کے آرڈر میں",
    "HSK لیول تجویز کے آرڈر میں",
    "اکثر استعمال حروف کے آرڈر میں",
  ];

  final List<String> modeDetails = [
    "Zihui میں 214 ریڈیکلز کا سیٹ ( یعنی چینی کریکٹر کا وہ حصّہ جو اس کے معنی کی نشاندہی کرتا ہے ) متعارف کیا گیا ہے۔ جو کہ ایک مقول کانگسی لغت کے نام پر رکھا گیا ہے۔ ریڈیکز کا یہ مقرر کردہ مجموعہ چینی حروف ( کریکٹرز ) کی درجہ بندی اور ترتیب کا معیاد بن گیا ہے۔",
    "اس نظام کے تحت چینی کریکٹرز کو اس طریقے سے ترتیب دی گئی ہے جو HSK v3.0 کے نئے نظام سے ملتی جلتی ہے۔ اگر آپ کے پاس پہلے سے اس کے پرنٹ شدہ نوٹس ہیں تو یہ ترتیب ( نظام ) آپ کے لئے بہت فائدے مند ثابت ہو سکتی ہے۔",
    "اس نظام میں چینی حروف کو ان کی فریکوئنسی کے مطابق ترتیب دی گئی ہے۔ جیسے فرض کیجیے اگر کوئی کریکٹر ایسا ہے جو بہت عام ہے اور عموماً استعمال ہوتا ہے تو اس کریکٹر کو دوسرے کریکٹرز سے پہلے سیکھنا ضروری ہے۔"
  ];

  final List<String> pageDesc = [
    "یہاں آپ اپنی مرضی کے مطابق ( HSK ) درجات کا انتخاب کر سکتے ہیں - یہ بات ذہن نشین کر لیجے کہ جیسے جیسے درجات بلند ہوتے جاتے ہیں ویسے  ویسے  چینی حروف مشکل ہوتےجاتے ہیں ۔ ابتدائی درجات (3 - 1) ، درمیانی درجات (6 - 4)، اعلیٰ درجات (9 - 7) اس کے علاوہ آخری درجےمیں آپ کو وہ چینی حروف ملیں گے جو بہت کم استعمال ہوتے ہیں -",
    "یہ وہ جگہ ہے جہاں آپ چینی حروف کی تعداد مقرر کر سکتے ہیں - یہ بات ذہن میں رکھیں کہ آپ 50 حروف یا اس سے زیاده کے حروف ایک وقفے میں سیکھ سکتے ہیں ( 50 سے کم نہیں ) - آپ سلائیڈر کے ذریعہ \"کہا سے شروع\" اور \"کہا پر ختم\" ان کو ترتیب دے سکتے ہیں یا یہ کام آپ ان بٹنوں سے بھی لے سکتے ہیں -",
    "یہ دو بٹن آپ کو یا تو \"ترتیب کے ساتھ\" یا پھر \"ترتیب کے بغیر\" چینی سکھنے میں مدد کرتے ہیں - ان دونوں کے اپنے اپنے فوائد اور نقصانات ہے ، لیکن یہ بھی ذہن میں رہے کہ نیچے \"ترتیب کی اقسام\" کا آپشن اس وقت تک قابل رسائی رہے گا جب تک \"ترتیب کے ساتھ\" ( سبز بٹن ) منتخب ہوا ہو ۔",
    "آخر میں ، یہاں آپ ترتیب کی قسم کو منتخب کر سکتے ہیں ، ان میں سے ہر ایک کا اپنا اپنا منفرد استعمال ہے ۔ جہاں تک ان کی مزید تفصیلات کے بارے میں بات ہے تو آپ ان کے معلوماتی بیٹوں پر ٹیپ کرکے اسے پڑھ سکتے ہیں -"
  ];

  final List<CardData> _currCards = [];

  late int selectedHsk, selectedHskMode, selectedHskOrder, _minVal, _maxVal;

  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _maxButton = false;
  bool _minButton = false;
  bool _maxSliderTrigger = true;
  bool _minSliderTrigger = false;

  void levChars(int lev) {
    _currCards.clear();
    for (int i = 0; i < allCards.length; i++) {
      if (lev == allCards[i].getHskLev()) {
        _currCards.add(allCards[i]);
      }
    }

    if (selectedHskOrder == 0) {
      for (int i = 0; i < _currCards.length; i++) {
        _currCards[i].setHanID(_currCards[i].getRadHan());
      }
      _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
    } else if (selectedHskOrder == 1) {
      for (int i = 0; i < _currCards.length; i++) {
        _currCards[i].setHanID(_currCards[i].getLevHan());
      }
      _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
    } else if (selectedHskOrder == 2) {
      for (int i = 0; i < _currCards.length; i++) {
        _currCards[i].setHanID(_currCards[i].getComFreq());
      }
      _currCards.sort(((a, b) => a.getHanID().compareTo(b.getHanID())));
    }
  }

  void levInfoPressed(int idx) {
    if (idx == 0) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 1) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 2) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 3) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 4) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 5) {
      levChars(idx);
      levDialog(context);
    } else if (idx == 6) {
      levChars(idx);
      levDialog(context);
    } else {
      levChars(idx);
      levDialog(context);
    }
  }

  void levDialog(BuildContext context) {
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
                  itemCount: _currCards.length,
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
                            _currCards[index].getHanSimp(),
                            style: TextStyle(
                                fontFamily: 'kaiti',
                                fontSize: 44,
                                color: hskColour(_currCards[index].getHskLev(),
                                    _darkModeEnabled)),
                          ),
                          subtitle: Text(
                            " اس حرف کی فریکوئنسی (${_currCards[index].getComFreq() + 1})",
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

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<HskLevel> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    items.asMap().forEach((idx, item) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            onTap: () => setState(() {
              if (item.isUnlocked == false) {
                if (idx > 3) {
                  workProgDialog(context);
                } else {
                  buyLevDialog(context, _darkModeEnabled, idx);
                }
              }
            }),
            value: item.getHskLevel(),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      item.getHskLevel(),
                      style: TextStyle(
                          fontSize: 18,
                          color: item.isUnlocked == true
                              ? Colors.grey[800]
                              : Colors.grey),
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                        onPressed: () {
                          levInfoPressed(idx);
                        },
                        icon: Icon(
                          Icons.info,
                          size: 28,
                          color: _darkModeEnabled
                              ? Colors.grey[800]
                              : Colors.lightBlue[800],
                        )),
                    IconButton(
                        onPressed: () {
                          if (item.isUnlocked == false) {
                            if (idx > 3) {
                              workProgDialog(context);
                            } else {
                              buyLevDialog(context, _darkModeEnabled, idx);
                            }
                          }
                        },
                        icon: Icon(
                            item.getIsUnlocked() == true
                                ? Icons.lock_open
                                : Icons.lock,
                            color: item.getIsUnlocked() == true
                                ? Colors.grey[800]
                                : Colors.redAccent))
                  ],
                )),
          ),
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    });
    return menuItems;
  }

  void modeInfoPressed(int idx) {
    if (selectedHskMode != 1) {
      if (idx == 0) {
        modeDialog(context, modeDetails[0], 0);
      } else if (idx == 1) {
        modeDialog(context, modeDetails[1], 1);
      } else {
        modeDialog(context, modeDetails[2], 2);
      }
    }
  }

  List<DropdownMenuItem<String>> _addDividersAfterItemsSeq(List<String> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    items.asMap().forEach((idx, item) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(children: <Widget>[
                  IconButton(
                      onPressed: () {
                        modeInfoPressed(idx);
                      },
                      icon: Icon(Icons.info,
                          size: 28,
                          color: selectedHskMode == 1
                              ? Colors.grey
                              : _darkModeEnabled == false
                                  ? Colors.lightBlue[800]
                                  : Colors.grey[800])),
                  const Spacer(flex: 1),
                  Text(
                    item,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            selectedHskMode == 1 ? Colors.grey : Colors.black),
                    textDirection: TextDirection.rtl,
                  ),
                ]),
              )),
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    });
    return menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> dividersIndexes = [];
    for (var i = 0; i < (hskLev.length * 2) - 1; i++) {
      if (i.isOdd) {
        dividersIndexes.add(i);
      }
    }
    return dividersIndexes;
  }

  void _sliderButtonPressed() async {
    if (_loopActive) return;
    _loopActive = true;
    while (_buttonPressed) {
      setState(() {
        if (_maxButton && _maxSliderTrigger) {
          if (_maxVal != hskLev[selectedHsk].getHskChars()) {
            _maxVal++;
          } else {
            return;
          }
        } else if (_minButton && _maxSliderTrigger) {
          if ((_maxVal - _minVal) >= 50) {
            _maxVal--;
          } else {
            return;
          }
        } else if (_maxButton && _minSliderTrigger) {
          if ((_maxVal - _minVal) >= 50) {
            _minVal++;
          } else {
            return;
          }
        } else if (_minButton && _minSliderTrigger) {
          if (_minVal != 1) {
            _minVal--;
          } else {
            return;
          }
        }
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _loopActive = false;
  }

  void pageInfo() {
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          ShowCaseWidget.of(context)
              .startShowCase([keyOne, keyTwo, keyThr, keyFor])
        });
  }

  @override
  void initState() {
    super.initState();
    selectedHsk = 0;
    selectedHskMode = 0;
    selectedHskOrder = 0;
    _minVal = 1;
    _maxVal = 50;
  }

  @override
  Widget build(BuildContext context) {
    _darkModeEnabled = checkTheme(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    //double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Theme(
                                  data: ThemeData(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent),
                                  child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Container(
                                          height: 50,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          child: Showcase.withWidget(
                                              key: keyOne,
                                              onTargetClick: () => null,
                                              width: width,
                                              height: 200,
                                              disableMovingAnimation: true,
                                              targetBorderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(15.0)),
                                              container: Container(
                                                  width: width - 30,
                                                  height: 270,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 3, 10, 0),
                                                        child: Text(pageDesc[0],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                            textAlign: TextAlign
                                                                .justify,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl)),
                                                    getVoiceRow(
                                                        context,
                                                        assetsAudioPlayer,
                                                        true,
                                                        false,
                                                        _darkModeEnabled,
                                                        _playAudio,
                                                        1)
                                                  ])),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  isExpanded: true,
                                                  items: _addDividersAfterItems(
                                                      hskLev),
                                                  dropdownPadding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  dropdownOverButton: true,
                                                  dropdownMaxHeight: 310,
                                                  value: hskLev[selectedHsk]
                                                      .getHskLevel(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value as String ==
                                                          hskLev[0]
                                                              .getHskLevel()) {
                                                        selectedHsk = 0;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[1]
                                                              .getHskLevel()) {
                                                        selectedHsk = 1;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[2]
                                                              .getHskLevel()) {
                                                        selectedHsk = 2;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[3]
                                                              .getHskLevel()) {
                                                        selectedHsk = 3;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[4]
                                                              .getHskLevel()) {
                                                        selectedHsk = 4;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[5]
                                                              .getHskLevel()) {
                                                        selectedHsk = 5;
                                                        _minVal = 1;
                                                        _maxVal = 50;
                                                      } else if (value ==
                                                          hskLev[6]
                                                              .getHskLevel()) {
                                                        selectedHsk = 6;
                                                        _minVal = 1;
                                                        _maxVal = 300;
                                                      } else {
                                                        selectedHsk = 7;
                                                        _minVal = 1;
                                                        _maxVal = 100;
                                                      }
                                                    });
                                                  },
                                                  itemHeight: 45,
                                                ),
                                              )))))),
                          Material(
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 5,
                              color: _darkModeEnabled == true
                                  ? Colors.grey[900]
                                  : Colors.white,
                              child: Container(
                                  width: width - 30,
                                  decoration: BoxDecoration(
                                    color: _darkModeEnabled
                                        ? Colors.grey[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: 5, right: 20, bottom: 5),
                                  child: Row(children: <Widget>[
                                    const Spacer(flex: 1),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Image.asset(
                                            "assets/images/home/hskch/$selectedHsk.png",
                                            width: 130,
                                            height: 130)),
                                    const Spacer(flex: 1),
                                    Column(children: <Widget>[
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                hskLev[selectedHsk]
                                                    .getHskChars()
                                                    .toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  color: _darkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                            Text("کُل حروف: ",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  color: _darkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                          ]),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(_minVal.toString(),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: const TextStyle(
                                                  color: Colors.lightGreen,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                            const Text("پہلا حرف: ",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                          ]),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text((_maxVal.toString()),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                            const Text("آخری حرف: ",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                          ]),
                                    ])
                                  ]))),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10),
                              child: Showcase.withWidget(
                                  key: keyTwo,
                                  onTargetClick: () => null,
                                  disableMovingAnimation: true,
                                  width: width,
                                  height: 200,
                                  targetBorderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  container: Container(
                                      width: width - 30,
                                      height: 240,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Column(children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 3, 10, 0),
                                            child: Text(pageDesc[1],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                textAlign: TextAlign.justify,
                                                textDirection:
                                                    TextDirection.rtl)),
                                        getVoiceRow(
                                            context,
                                            assetsAudioPlayer,
                                            false,
                                            false,
                                            _darkModeEnabled,
                                            _playAudio,
                                            2)
                                      ])),
                                  child: SizedBox(
                                      height: 47,
                                      width: width - 29,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Theme(
                                                data: ThemeData(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                ),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    elevation: 5,
                                                    child: Container(
                                                        height: 45,
                                                        width: 45,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                            onTapCancel: () => {
                                                                  _buttonPressed =
                                                                      false,
                                                                  _minButton =
                                                                      false
                                                                },
                                                            onTapDown:
                                                                (details) {
                                                              _buttonPressed =
                                                                  true;
                                                              _minButton = true;
                                                              _sliderButtonPressed();
                                                            },
                                                            onTapUp: (details) {
                                                              _buttonPressed =
                                                                  false;
                                                              _minButton =
                                                                  false;
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: const Icon(
                                                                Icons
                                                                    .remove))))),
                                            Expanded(
                                                child: FlutterSlider(
                                              handler: FlutterSliderHandler(
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.blue,
                                                    size: 25,
                                                  )),
                                              rightHandler:
                                                  FlutterSliderHandler(
                                                decoration:
                                                    const BoxDecoration(),
                                                child: const Icon(
                                                  Icons.circle,
                                                  color: Colors.blue,
                                                  size: 25,
                                                ),
                                              ),
                                              handlerAnimation:
                                                  const FlutterSliderHandlerAnimation(
                                                      scale: 1),
                                              tooltip: FlutterSliderTooltip(
                                                  disabled: true),
                                              selectByTap: true,
                                              handlerWidth: 30,
                                              handlerHeight: 30,
                                              minimumDistance: 49,
                                              values: [
                                                _minVal.toDouble(),
                                                _maxVal.toDouble()
                                              ],
                                              rangeSlider: true,
                                              min: 1,
                                              max: hskLev[selectedHsk]
                                                  .getHskChars()
                                                  .toDouble(),
                                              onDragging: (handlerIndex,
                                                  lowerValue, upperValue) {
                                                setState(() {
                                                  _minVal = lowerValue.round();
                                                  _maxVal = upperValue.round();

                                                  if (handlerIndex == 1) {
                                                    _minSliderTrigger = false;
                                                    _maxSliderTrigger = true;
                                                  } else {
                                                    _minSliderTrigger = true;
                                                    _maxSliderTrigger = false;
                                                  }
                                                });
                                              },
                                            )),
                                            Theme(
                                                data: ThemeData(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                ),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    elevation: 5,
                                                    child: Container(
                                                        height: 45,
                                                        width: 45,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                            onTapCancel: () => {
                                                                  _buttonPressed =
                                                                      false,
                                                                  _maxButton =
                                                                      false
                                                                },
                                                            onTapDown:
                                                                (details) {
                                                              _buttonPressed =
                                                                  true;
                                                              _maxButton = true;
                                                              _sliderButtonPressed();
                                                            },
                                                            onTapUp: (details) {
                                                              _buttonPressed =
                                                                  false;
                                                              _maxButton =
                                                                  false;
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: const Icon(
                                                                Icons.add))))),
                                          ])))),
                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Showcase.withWidget(
                                  key: keyThr,
                                  onTargetClick: () => null,
                                  disableMovingAnimation: true,
                                  width: width,
                                  height: 200,
                                  targetBorderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  container: Container(
                                      width: width - 30,
                                      height: 215,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Column(children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 3, 10, 0),
                                            child: Text(pageDesc[2],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                                textAlign: TextAlign.justify,
                                                textDirection:
                                                    TextDirection.rtl)),
                                        getVoiceRow(
                                            context,
                                            assetsAudioPlayer,
                                            false,
                                            false,
                                            _darkModeEnabled,
                                            _playAudio,
                                            3)
                                      ])),
                                  child: SizedBox(
                                      height: 46,
                                      width: width - 29,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Spacer(flex: 1),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    elevation: 5,
                                                    color:
                                                        _darkModeEnabled == true
                                                            ? Colors.grey[900]
                                                            : Colors.white,
                                                    child: Container(
                                                        height: 45,
                                                        width: 160,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: selectedHskMode ==
                                                                      1
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .transparent,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                        ),
                                                        child: Theme(
                                                            data: ThemeData(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                            ),
                                                            child: InkWell(
                                                                onTap: () =>
                                                                    setState(
                                                                        () {
                                                                      if (selectedHskMode !=
                                                                          1) {
                                                                        selectedHskMode =
                                                                            1;
                                                                      }
                                                                    }),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10.0),
                                                                child: const Text(
                                                                    "ترتیب کے بغیر",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color: Colors
                                                                            .redAccent,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)))))),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    elevation: 5,
                                                    color:
                                                        _darkModeEnabled == true
                                                            ? Colors.grey[900]
                                                            : Colors.white,
                                                    child: Container(
                                                        height: 45,
                                                        width: 160,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: selectedHskMode ==
                                                                      0
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .transparent,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                10.0),
                                                          ),
                                                        ),
                                                        child: Theme(
                                                            data: ThemeData(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                            ),
                                                            child: InkWell(
                                                                onTap: () =>
                                                                    setState(
                                                                        () {
                                                                      if (selectedHskMode !=
                                                                          0) {
                                                                        selectedHskMode =
                                                                            0;
                                                                      }
                                                                    }),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10.0),
                                                                child: const Text(
                                                                    "ترتیب کے ساتھ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color: Colors
                                                                            .lightGreen,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)))))),
                                            const Spacer(flex: 1),
                                          ])))),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, right: 15),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Theme(
                                      data: ThemeData(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent),
                                      child: Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                              height: 45,
                                              width: width - 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: Showcase.withWidget(
                                                  key: keyFor,
                                                  onTargetClick: () => null,
                                                  disableMovingAnimation: true,
                                                  width: width,
                                                  height: 200,
                                                  targetBorderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  container: Container(
                                                      width: width - 30,
                                                      height: 186,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0)),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            3,
                                                                            10,
                                                                            0),
                                                                child: Text(
                                                                    pageDesc[3],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl)),
                                                            getVoiceRow(
                                                                context,
                                                                assetsAudioPlayer,
                                                                false,
                                                                true,
                                                                _darkModeEnabled,
                                                                _playAudio,
                                                                4)
                                                          ])),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton2(
                                                      iconEnabledColor:
                                                          selectedHskMode == 1
                                                              ? Colors.grey
                                                              : Colors.black,
                                                      isExpanded: true,
                                                      items:
                                                          _addDividersAfterItemsSeq(
                                                              hskSequence),
                                                      dropdownDecoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      dropdownOverButton: true,
                                                      dropdownMaxHeight:
                                                          selectedHskMode == 0
                                                              ? 155
                                                              : 0,
                                                      value: hskSequence[
                                                          selectedHskOrder],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value as String ==
                                                              hskSequence[0]) {
                                                            selectedHskOrder =
                                                                0;
                                                          } else if (value ==
                                                              hskSequence[1]) {
                                                            selectedHskOrder =
                                                                1;
                                                          } else if (value ==
                                                              hskSequence[2]) {
                                                            selectedHskOrder =
                                                                2;
                                                          }
                                                        });
                                                      },
                                                      itemHeight: 45,
                                                    ),
                                                  ))))))),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 35, bottom: 10),
                              child: Row(children: <Widget>[
                                const Spacer(flex: 1),
                                Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: getCustomQuizButton(
                                        context,
                                        _darkModeEnabled,
                                        selectedHsk,
                                        selectedHskMode,
                                        selectedHskOrder,
                                        _minVal,
                                        _maxVal - 1,
                                        0)),
                                Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: getCustomQuizButton(
                                        context,
                                        _darkModeEnabled,
                                        selectedHsk,
                                        selectedHskMode,
                                        selectedHskOrder,
                                        _minVal - 1,
                                        _maxVal - 1,
                                        1)),
                                const Spacer(flex: 1),
                              ]))
                        ])))));
  }
}
