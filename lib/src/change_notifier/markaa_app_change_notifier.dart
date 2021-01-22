import 'package:flutter/material.dart';

class MarkaaAppChangeNotifier extends ChangeNotifier {
  void rebuild() {
    notifyListeners();
  }
}
