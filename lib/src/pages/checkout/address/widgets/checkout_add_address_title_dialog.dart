import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddAddressTitleDialog extends StatefulWidget {
  final PageStyle pageStyle;

  CheckoutAddAddressTitleDialog({this.pageStyle});

  @override
  _CheckoutAddAddressTitleDialogState createState() =>
      _CheckoutAddAddressTitleDialogState();
}

class _CheckoutAddAddressTitleDialogState
    extends State<CheckoutAddAddressTitleDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white70,
      child: CupertinoAlertDialog(
        title: Text(
          'checkout_your_address_title'.tr(),
          textAlign: TextAlign.center,
          style: mediumTextStyle.copyWith(
            fontSize: widget.pageStyle.unitFontSize * 26,
            color: Colors.black,
          ),
        ),
        content: Form(
          key: formKey,
          child: MarkaaInputField(
            width: double.infinity,
            controller: titleController,
            space: widget.pageStyle.unitHeight * 4,
            radius: 4,
            fontSize: widget.pageStyle.unitFontSize * 16,
            fontColor: greyDarkColor,
            label: '',
            labelColor: greyColor,
            labelSize: 0,
            fillColor: Colors.white,
            bordered: false,
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.pop(context, titleController.text);
              }
            },
            child: Text(
              'save_button_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 18,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
