import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_input_multi.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class DeliverAsGiftForm extends StatefulWidget {
  final OrderChangeNotifier orderChangeNotifier;
  DeliverAsGiftForm({this.orderChangeNotifier});
  @override
  _DeliverAsGiftFormState createState() => _DeliverAsGiftFormState();
}

class _DeliverAsGiftFormState extends State<DeliverAsGiftForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _senderEmailController = TextEditingController();
  final _messageController = TextEditingController();
  _sendGift() async {
    if (_formKey.currentState.validate()) {
      var _res = await widget.orderChangeNotifier.sendAsGift(_senderEmailController.text, _messageController.text);
      Navigator.of(context).pop(_res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(giftIcon),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'deliver_as_gift'.tr(),
                              style: mediumTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              'special_reopen_special_message'.tr(),
                              style: mediumTextStyle.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(closeIcon),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              MarkaaInputField(
                width: double.infinity,
                controller: _senderEmailController,
                radius: 4.sp,
                fontSize: 12.sp,
                fontColor: darkColor,
                label: '',
                labelColor: darkColor,
                labelSize: 12.sp,
                hint: 'receiver_email'.tr(),
                hintSize: 12.sp,
                hintColor: greyDarkColor,
                fillColor: greyLightColor,
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) return 'required'.tr();
                },
              ),
              SizedBox(height: 10.h),
              MarkaaTextInputMulti(
                width: double.infinity,
                controller: _messageController,
                borderRadius: 4.sp,
                fontSize: 12.sp,
                hint: 'message'.tr(),
                validator: (String value) {
                  if (value.isEmpty) return 'required'.tr();
                },
                padding: 0.w,
                inputType: TextInputType.text,
                borderColor: Colors.transparent,
                fillColor: greyLightColor,
                maxLine: 5,
              ),
              SizedBox(height: 30.h),
              Container(
                width: 300.w,
                height: 45.h,
                child: MarkaaTextButton(
                  title: 'done'.tr(),
                  titleSize: 14.sp,
                  titleColor: Colors.white,
                  buttonColor: primaryColor,
                  borderColor: primaryColor,
                  onPressed: _sendGift,
                  radius: 30.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
