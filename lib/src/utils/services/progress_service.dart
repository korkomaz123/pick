import 'package:markaa/config.dart';
import 'package:markaa/src/components/markaa_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressService {
  final BuildContext context;

  ProgressService({this.context});

  void showProgress([double opacity = 0.01]) async {
    await showDialog(
      context: Config.navigatorKey.currentContext,
      barrierColor: opacity == 1 ? Colors.white : Colors.white.withOpacity(opacity),
      builder: (context) {
        return MarkaaLoadingDialog();
      },
    );
  }

  void hideProgress() {
    Navigator.pop(Config.navigatorKey.currentContext);
  }
}
