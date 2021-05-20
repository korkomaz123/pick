import 'package:flutter/material.dart';

class MarkaaAppChangeNotifier extends ChangeNotifier {
  bool activeSaveForLater = true;

  bool activePutInCart = true;

  bool buying = false;

  void rebuild() {
    notifyListeners();
  }

  void changeSaveForLaterStatus(bool value) {
    activeSaveForLater = value;
    notifyListeners();
  }

  void changePutInCartStatus(bool value) {
    activePutInCart = value;
    notifyListeners();
  }

  void changeBuyStatus(bool value) {
    buying = value;
    notifyListeners();
  }
}
