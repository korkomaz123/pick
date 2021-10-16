import 'package:markaa/src/components/markaa_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';

class ProgressService {
  final BuildContext context;

  ProgressService({required this.context});

  void showProgress([double opacity = 0.01]) async {
    await showDialog(
      context: context,
      barrierColor:
          opacity == 1 ? Colors.white : Colors.white.withOpacity(opacity),
      builder: (context) {
        return MarkaaLoadingDialog();
      },
    );
  }

  void hideProgress() {
    Navigator.pop(context);
  }

  void addingProductProgress() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: DualRingSpinner(),
          ),
        );
      },
    );
  }
}
