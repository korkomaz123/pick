import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final PageStyle pageStyle;

  LogoutConfirmDialog({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'logout_confirm_dialog_title'.tr(),
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
          color: Colors.black,
        ),
      ),
      content: Text(
        'logout_confirm_dialog_text'.tr(),
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 15,
          color: Colors.black87,
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context, 'yes'),
          child: Text(
            'yes_button_title'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'no_button_title'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
