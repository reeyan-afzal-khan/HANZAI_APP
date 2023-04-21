// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:hanzai_app/widgets/dialog_workInProg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//Models
import 'package:hanzai_app/model/card_model.dart';

//Functions
import '../functions/hsk_colour.dart';
import 'package:hanzai_app/functions/theme_check.dart';

import 'hanzi_orc.dart';

class OCR extends StatefulWidget {
  const OCR({Key? key}) : super(key: key);

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> with SingleTickerProviderStateMixin {
  late bool _darkModeEnabled;

  String _ocrText = '';

  final List<String> _allOCRText = [];
  final List<int> _allOCRLev = [];
  final List<int> _allOCRIndex = [];

  String path = "";
  bool bload = false;

  void runFilePiker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  void runFilePikerCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  Future<void> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'جتنے کم کریکٹرز اتنا بہتر نتیجہ',
            toolbarColor: Colors.lightBlue[800],
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: false,
            cropGridRowCount: 0,
            cropGridColumnCount: 0),
        IOSUiSettings(title: 'جتنے کم کریکٹرز اتنا بہتر نتیجہ')
      ],
    );
    if (croppedFile != null) {
      _ocr(croppedFile.path);
    }
  }

  void _ocr(url) async {
    path = url;
    bload = true;
    //setState(() {});

    _ocrText =
        await FlutterTesseractOcr.extractText(url, language: 'chi_sim', args: {
      "preserve_interword_spaces": "1",
    });

    _ocrText = _ocrText.replaceAll("。", "");

    for (var rune in _ocrText.runes) {
      var char = String.fromCharCode(rune);

      var index =
          // ignore: avoid_types_as_parameter_names
          allCards.indexWhere((CardData) => CardData.getHanSimp() == char);

      if (index != -1) {
        _allOCRText.add(allCards[index].getHanSimp());
        _allOCRLev.add(allCards[index].getHskLev());
        _allOCRIndex.add(allCards[index].getRadHan());
      }
    }
    bload = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _darkModeEnabled = checkTheme(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  path.isEmpty
                      ? Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _darkModeEnabled == false
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  width: 2)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.search, size: 100),
                                Text(
                                  "کوئی تصویر یا\n اسکرین شاٹ اپ لوڈ کریں",
                                  style: TextStyle(
                                      fontFamily: "nastaliq_urdu",
                                      fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ]))
                      : Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _darkModeEnabled == false
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  width: 2)),
                          child: Image.file(File(path))),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),
                        FloatingActionButton(
                          heroTag: "btn2",
                          mini: true,
                          onPressed: () {
                            _allOCRText.clear();
                            _allOCRLev.clear();
                            _allOCRIndex.clear();
                            runFilePiker();
                          },
                          backgroundColor: _darkModeEnabled == false
                              ? Colors.lightBlue[800]
                              : Colors.grey[800],
                          tooltip: 'تصویر چنندہ',
                          child: const Icon(Icons.collections, size: 25),
                        ),
                        FloatingActionButton(
                          heroTag: "btn1",
                          mini: true,
                          onPressed: () {
                            _allOCRText.clear();
                            _allOCRLev.clear();
                            _allOCRIndex.clear();
                            runFilePikerCamera();
                          },
                          backgroundColor: _darkModeEnabled == false
                              ? Colors.lightBlue[800]
                              : Colors.grey[800],
                          tooltip: 'کیمرہ',
                          child: const Icon(Icons.photo_camera, size: 25),
                        ),
                        const Spacer(flex: 3),
                      ]),
                  const Divider(height: 5),
                  SizedBox(
                      height: (height / 2) - 150,
                      width: width - 20,
                      child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: Colors.transparent,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _allOCRText.length,
                                itemBuilder: (_, int index) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Theme(
                                          data: ThemeData(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent),
                                          child: ListTile(
                                            onTap: () => {
                                              if (_allOCRLev[index] <= 3)
                                                {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HanziLearn(
                                                                  currentCard:
                                                                      _allOCRIndex[
                                                                          index])))
                                                }
                                              else
                                                {workProgDialog(context)},
                                            },
                                            trailing: Text(
                                              _allOCRText[index],
                                              style: TextStyle(
                                                  fontFamily: 'kaiti',
                                                  fontSize: 44,
                                                  color: hskColour(
                                                      _allOCRLev[index],
                                                      _darkModeEnabled)),
                                            ),
                                            subtitle: Text(
                                              hskLev(_allOCRLev[index]),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          )));
                                }),
                          ))),
                ],
              )),
        ],
      ),
    );
  }

  String hskLev(int index) {
    if (index == 0) {
      return 'یہ حرف HSK لیول (1) میں موجود ہے ';
    } else if (index == 1) {
      return 'یہ حرف HSK لیول (2) میں موجود ہے ';
    } else if (index == 2) {
      return 'یہ حرف HSK لیول (3) میں موجود ہے ';
    } else if (index == 3) {
      return 'یہ حرف HSK لیول (4) میں موجود ہے ';
    } else if (index == 4) {
      return 'یہ حرف HSK لیول (5) میں موجود ہے ';
    } else if (index == 5) {
      return 'یہ حرف HSK لیول (6) میں موجود ہے ';
    } else if (index == 6) {
      return 'یہ حرف HSK لیول (9-7) میں موجود ہے ';
    } else {
      return 'یہ حرف HSK لیول (+9) میں موجود ہے ';
    }
  }
}
