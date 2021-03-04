import 'package:flutter/material.dart';

class ScrollChangeNotifier with ChangeNotifier {
  double scrollPosition = 0.0;
  bool showBrandBar = true;
  bool showScrollBar = false;

  void initialize() {
    scrollPosition = 0.0;
    showBrandBar = true;
    showScrollBar = false;
    notifyListeners();
  }

  void updateScrollStatus(double updatePosition) {
    scrollPosition = updatePosition;
    notifyListeners();
  }

  void controlBrandBar(double pos) {
    if (showBrandBar && pos > 60 || !showBrandBar && pos < 60) {
      showBrandBar = !showBrandBar;
      notifyListeners();
    }
    if (!showScrollBar && pos > 60) {
      showScrollBar = true;
      notifyListeners();
    } else if (showScrollBar && pos < 60) {
      showScrollBar = false;
      notifyListeners();
    }
  }
}
