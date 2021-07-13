import 'package:flutter/material.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
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
  @override
  _DeliverAsGiftFormState createState() => _DeliverAsGiftFormState();
}

class _DeliverAsGiftFormState extends State<DeliverAsGiftForm> {
  final _formKey = GlobalKey<FormState>();
  final _senderController = TextEditingController();
  final _receiverController = TextEditingController();
  final _messageController = TextEditingController();

  OrderChangeNotifier _orderChangeNotifier;
  ProgressService _progressService;
  FlushBarService _flushBarService;

  @override
  void initState() {
    super.initState();
    _orderChangeNotifier = context.read<OrderChangeNotifier>();
    _progressService = ProgressService(context: context);
    _flushBarService = FlushBarService(context: context);
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
                controller: _senderController,
                radius: 4.sp,
                fontSize: 12.sp,
                fontColor: darkColor,
                label: '',
                labelColor: darkColor,
                labelSize: 12.sp,
                hint: 'sender_hint'.tr(),
                hintSize: 12.sp,
                hintColor: greyDarkColor,
                fillColor: greyLightColor,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'required_field'.tr();
                  }
                  return null;
                },
              ),
              MarkaaInputField(
                width: double.infinity,
                controller: _receiverController,
                radius: 4.sp,
                fontSize: 12.sp,
                fontColor: darkColor,
                label: '',
                labelColor: darkColor,
                labelSize: 12.sp,
                hint: 'receiver_hint'.tr(),
                hintSize: 12.sp,
                hintColor: greyDarkColor,
                fillColor: greyLightColor,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'required_field'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              MarkaaTextInputMulti(
                width: double.infinity,
                controller: _messageController,
                borderRadius: 4.sp,
                fontSize: 12.sp,
                hint: 'message'.tr(),
                padding: 0.w,
                inputType: TextInputType.text,
                borderColor: Colors.transparent,
                fillColor: greyLightColor,
                maxLine: 5,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'required_field'.tr();
                  }
                  return null;
                },
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
                  onPressed: _onDone,
                  radius: 30.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onDone() {
    if (_formKey.currentState.validate()) {
      _orderChangeNotifier.sendAsGift(
          token: user?.token,
          sender: _senderController.text,
          receiver: _receiverController.text,
          message: _messageController.text,
          onProcess: _onProcess,
          onSuccess: _onSuccess,
          onFailure: _onFailure);
    }
  }

  _onProcess() {
    _progressService.showProgress();
  }

  _onSuccess(String giftMessageId) {
    _progressService.hideProgress();
    Navigator.pop(context, giftMessageId);
  }

  _onFailure(String message) {
    _progressService.hideProgress();
    _flushBarService.showErrorMessage(message);
  }
}
