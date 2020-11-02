import 'package:ciga/src/components/ciga_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressService {
  final BuildContext context;

  ProgressService({this.context});

  void showProgress() {
    showDialog(
      context: context,
      builder: (context) {
        return CigaLoadingDialog();
      },
    );
  }

  void hideProgress() {
    Navigator.pop(context);
  }
}
