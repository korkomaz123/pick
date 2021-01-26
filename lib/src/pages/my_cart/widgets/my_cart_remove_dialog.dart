import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartRemoveDialog extends StatelessWidget {
  final PageStyle pageStyle;
  final String title;
  final String text;

  MyCartRemoveDialog({this.pageStyle, this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
          color: Colors.black,
        ),
      ),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 15,
          color: Colors.black87,
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context, 'yes'),
          child: Text(
            'yes_button_title'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'no_button_title'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
