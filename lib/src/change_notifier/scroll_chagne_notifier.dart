import 'package:flutter/material.dart';

class ScrollChangeNotifier with ChangeNotifier {
  double scrollPosition = 0.0;
  bool showBrandBar = true;

  void updateScrollStatus(double updatePosition) {
    scrollPosition = updatePosition;
    notifyListeners();
  }

  void controlBrandBar(double pos) {
    if (showBrandBar && pos > 60 || !showBrandBar && pos < 60) {
      showBrandBar = !showBrandBar;
      notifyListeners();
    }
  }
}
