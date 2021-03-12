import 'package:markaa/src/components/markaa_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressService {
  final BuildContext context;

  ProgressService({this.context});

  void showProgress([double opacity = 0.01]) async {
    await showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(opacity),
      builder: (context) {
        return MarkaaLoadingDialog();
      },
    );
  }

  void hideProgress() {
    Navigator.pop(context);
  }
}
