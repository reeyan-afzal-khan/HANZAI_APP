import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HskLevel {
  @required
  String hskLev;
  @required
  int hskChars;
  @required
  bool isUnlocked;

  String getHskLevel() {
    return hskLev;
  }

  int getHskChars() {
    return hskChars;
  }

  bool getIsUnlocked() {
    return isUnlocked;
  }

  HskLevel(this.hskLev, this.hskChars, this.isUnlocked);
}
