import 'package:flutter/material.dart';

class ScrollChangeNotifier with ChangeNotifier {
  double scrollPosition = 0.0;

  void updateScrollStatus(double updatePosition) {
    scrollPosition = updatePosition;
    notifyListeners();
  }
}
