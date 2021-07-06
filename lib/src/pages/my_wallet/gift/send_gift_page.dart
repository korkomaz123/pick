import 'package:flutter/material.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/string_service.dart';
import 'package:string_validator/string_validator.dart';

class SendGiftPage extends StatefulWidget {
  final bool fromCheckout;

  SendGiftPage({this.fromCheckout});

  @override
  _SendGiftPageState createState() => _SendGiftPageState();
}

class _SendGiftPageState extends State<SendGiftPage> {
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();

  bool isValid = false;

  WalletChangeNotifier _walletChangeNotifier;
  ProgressService _progressService;
  FlushBarService _flushBarService;

  @override
  void initState() {
    super.initState();

    _amountController.addListener(_onChange);
    _emailController.addListener(_onChange);

    _walletChangeNotifier = context.read<WalletChangeNotifier>();
    _progressService = ProgressService(context: context);
    _flushBarService = FlushBarService(context: context);
  }

  _onChange() {
    bool validEmail = true;
    bool validAmount = _amountController.text.isNotEmpty &&
        (isInt(_amountController.text) || isFloat(_amountController.text));
    isValid = validEmail && validAmount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Align(
              alignment: Preload.language == 'en'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close, color: greyDarkColor, size: 25.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              width: designWidth.w,
              height: 60.h,
              child: MarkaaTextIconButton(
                title: 'send_gift_title'.tr(),
                titleSize: 20.sp,
                titleColor: primaryColor,
                buttonColor: Colors.white,
                borderColor: Colors.transparent,
                icon: SvgPicture.asset(giftIcon),
                onPressed: () => null,
              ),
            ),
            SizedBox(height: 20.h),
            _buildFriendInputField(),
            SizedBox(height: 20.h),
            _buildAmountInputField(),
            SizedBox(height: 20.h),
            Container(
              width: 200.w,
              child: MarkaaTextButton(
                title: 'send_button_title'.tr(),
                titleSize: 13.sp,
                titleColor: Colors.white,
                buttonColor: isValid ? primaryColor : greyColor,
                borderColor: Colors.transparent,
                onPressed: () {
                  if (isValid) {
                    _onTransferMoney();
                  }
                },
                isBold: true,
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendInputField() {
    return Container(
      width: 280.w,
      height: 43.h,
      child: TextFormField(
        controller: _emailController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'enter_email_phone_number_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            fontSize: 13.sp,
            color: greyColor,
          ),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAmountInputField() {
    return Container(
      width: 280.w,
      height: 43.h,
      child: TextFormField(
        controller: _amountController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 3,
        buildCounter: (
          BuildContext context, {
          int currentLength,
          int maxLength,
          bool isFocused,
        }) =>
            null,
        decoration: InputDecoration(
          hintText: 'enter_amount_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            fontSize: 13.sp,
            color: greyColor,
          ),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Container(
            width: 40.w,
            margin: EdgeInsets.symmetric(vertical: 5.h),
            decoration: BoxDecoration(
              border: Preload.language == 'en'
                  ? Border(
                      left: BorderSide(
                        width: 0.5.w,
                        color: primaryColor,
                      ),
                    )
                  : Border(
                      right: BorderSide(
                        width: 0.5.w,
                        color: primaryColor,
                      ),
                    ),
            ),
            alignment: Alignment.center,
            child: Text(
              'kwd'.tr(),
              textAlign: TextAlign.center,
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTransferMoney() async {
    if (StringService.roundDouble(_amountController.text, 3) <= user.balance) {
      String message = 'transfer_amount_confirm_message'
          .tr()
          .replaceFirst(
              '#', StringService.roundString(_amountController.text, 3))
          .replaceFirst('@', _emailController.text);
      final result = await _flushBarService.showConfirmDialog(message: message);
      if (result != null) {
        _walletChangeNotifier.transferMoney(
          token: user.token,
          amount: _amountController.text,
          lang: Preload.language,
          description: 'gift',
          email: _emailController.text,
          onProcess: _onProcess,
          onSuccess: _onSuccess,
          onFailure: _onFailure,
        );
      }
    } else {
      _flushBarService.showErrorDialog(
        'not_enough_wallet'.tr(),
      );
    }
  }

  _onProcess() {
    _progressService.showProgress();
  }

  _onSuccess() {
    _progressService.hideProgress();
    user.balance -= StringService.roundDouble(_amountController.text, 3);

    if (widget.fromCheckout) {
      Navigator.popUntil(
        context,
        (route) => route.settings.name == Routes.checkout,
      );
    } else {
      Navigator.popUntil(
        context,
        (route) => route.settings.name == Routes.account,
      );
    }
    Navigator.pushNamed(context, Routes.sentGiftSuccess,
        arguments: _amountController.text);
  }

  _onFailure(String message) {
    _progressService.hideProgress();
    _flushBarService.showErrorDialog(message);
  }
}
