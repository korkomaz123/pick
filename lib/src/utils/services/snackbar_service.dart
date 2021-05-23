import 'package:markaa/preload.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  SnackBarService({this.context, this.scaffoldKey});

  void showDefaultSnackBar(String message) {
    ScaffoldMessenger.of(Preload.navigatorKey.currentContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(Preload.navigatorKey.currentContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: dangerColor,
      ));
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(Preload.navigatorKey.currentContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: succeedColor,
      ),
    );
  }
}
