import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class NewPasswordSentDialog extends StatelessWidget with WidgetsBindingObserver {
  final PageStyle pageStyle;

  NewPasswordSentDialog({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: CupertinoAlertDialog(
          title: Text(
            'thankyou'.tr(),
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 26,
              color: Colors.black,
            ),
          ),
          content: Text(
            'new_password_sent_message'.tr(),
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 15,
              color: Colors.black87,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'close'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 18,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
