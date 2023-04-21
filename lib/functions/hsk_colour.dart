import 'package:flutter/material.dart';

hskColour(int index, darkModeEnabled) {
  if (index == 0) {
    return const Color.fromARGB(255, 247, 207, 28);
  } else if (index == 1) {
    return const Color.fromARGB(255, 28, 127, 150);
  } else if (index == 2) {
    return const Color.fromARGB(255, 237, 110, 5);
  } else if (index == 3) {
    return const Color.fromARGB(255, 184, 16, 29);
  } else if (index == 4) {
    return const Color.fromARGB(255, 26, 61, 119);
  } else if (index == 5) {
    return const Color.fromARGB(255, 104, 54, 105);
  } else if (index == 6) {
    return const Color.fromARGB(255, 55, 208, 244);
  } else {
    return darkModeEnabled == true ? Colors.white : Colors.black;
  }
}
