import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class UpdateAvailableDialog extends StatefulWidget {
  final String title;
  final String content;

  UpdateAvailableDialog({this.title, this.content});

  @override
  _UpdateAvailableDialogState createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  PageStyle pageStyle;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: boldTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 20,
          color: darkColor,
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: pageStyle.unitHeight * 10),
        child: Text(
          widget.content,
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 16,
          ),
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text('maybe_later'.tr()),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, 'update'),
          child: Text('update'.tr()),
        ),
      ],
    );
  }
}
