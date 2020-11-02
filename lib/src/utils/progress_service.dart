import 'package:ciga/src/components/ciga_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressService {
  final BuildContext context;

  ProgressService({this.context});

  void showProgress() async {
    await showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.01),
      builder: (context) {
        return CigaLoadingDialog();
      },
    );
  }

  void hideProgress() {
    Navigator.pop(context);
  }
}
