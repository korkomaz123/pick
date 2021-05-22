import 'package:flutter/material.dart';

class MarkaaAppChangeNotifier extends ChangeNotifier {
  bool activeSaveForLater = true;

  bool activePutInCart = true;

  bool activeUpdateCart = true;

  bool activeAddCart = true;

  bool buying = false;

  void rebuild() {
    notifyListeners();
  }

  void changeAddCartStatus(bool value) {
    if (value) {
      Future.delayed(Duration(milliseconds: 600), () {
        activeAddCart = value;
        notifyListeners();
      });
    } else {
      activeAddCart = value;
      notifyListeners();
    }
  }

  void changeUpdateCartStatus(bool value) {
    if (value) {
      Future.delayed(Duration(milliseconds: 600), () {
        activeUpdateCart = value;
        notifyListeners();
      });
    } else {
      activeUpdateCart = value;
      notifyListeners();
    }
  }

  void changeSaveForLaterStatus(bool value) {
    if (value) {
      Future.delayed(Duration(milliseconds: 600), () {
        activeSaveForLater = value;
        notifyListeners();
      });
    } else {
      activeSaveForLater = value;
      notifyListeners();
    }
  }

  void changePutInCartStatus(bool value) {
    if (value) {
      Future.delayed(Duration(milliseconds: 600), () {
        activePutInCart = value;
        notifyListeners();
      });
    } else {
      activePutInCart = value;
      notifyListeners();
    }
  }

  void changeBuyStatus(bool value) {
    buying = value;
    notifyListeners();
  }
}
