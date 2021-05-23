import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddAddressTitleDialog extends StatefulWidget {
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
            fontSize: 26.sp,
            color: Colors.black,
          ),
        ),
        content: Form(
          key: formKey,
          child: MarkaaInputField(
            width: double.infinity,
            controller: titleController,
            space: 4.h,
            radius: 4.sp,
            fontSize: 16.sp,
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
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.pop(context, titleController.text);
              }
            },
            child: Text(
              'save_button_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 18.sp,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
