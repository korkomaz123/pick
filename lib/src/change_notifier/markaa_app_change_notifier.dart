import 'package:flutter/material.dart';

class MarkaaAppChangeNotifier extends ChangeNotifier {
  bool activeSaveForLater = true;

  bool activePutInCart = true;

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
}
