import 'package:flutter/material.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:string_validator/string_validator.dart';

class MyWalletDetailsForm extends StatefulWidget {
  @override
  _MyWalletDetailsFormState createState() => _MyWalletDetailsFormState();
}

class _MyWalletDetailsFormState extends State<MyWalletDetailsForm> {
  final _amountController = TextEditingController();

  MarkaaAppChangeNotifier _markaaAppChangeNotifier;

  bool isValidAmount;

  @override
  void initState() {
    super.initState();
    isValidAmount = false;
    _markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    _amountController.addListener(_onChangeAmount);
  }

  void _onChangeAmount() {
    String value = _amountController.text;
    if (value.isNotEmpty && (isInt(value) || isFloat(value))) {
      isValidAmount = true;
    } else {
      isValidAmount = false;
    }
    _markaaAppChangeNotifier.rebuild();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(vertical: 25.h),
      color: greyLightColor,
      child: Form(
        child: Column(
          children: [
            Text(
              'wallet_amount_hint'.tr(),
              style: mediumTextStyle.copyWith(fontSize: 13.sp),
            ),
            SizedBox(height: 15.h),
            Container(
              width: 200.w,
              height: 33.h,
              child: TextFormField(
                controller: _amountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Container(
                    width: 40.w,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 0.5.w, color: primaryColor),
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
            ),
            Consumer<MarkaaAppChangeNotifier>(
              builder: (_, __, ___) {
                return Column(
                  children: [
                    SizedBox(height: 25.h),
                    Container(
                      width: 168.w,
                      height: 28.h,
                      child: MarkaaTextButton(
                        onPressed: () => null,
                        title: 'add_money'.tr(),
                        titleColor: Colors.white,
                        titleSize: 13.sp,
                        buttonColor:
                            isValidAmount ? primaryColor : greyLightColor,
                        borderColor:
                            isValidAmount ? Colors.transparent : Colors.white,
                        radius: 8.sp,
                        isBold: true,
                      ),
                    ),
                    SizedBox(height: 23.h),
                    Container(
                      width: 203.w,
                      height: 28.h,
                      child: MarkaaTextButton(
                        onPressed: () => isValidAmount
                            ? Navigator.pushNamed(context, Routes.bankList)
                            : null,
                        title: 'transfer_amount_to_bank'.tr(),
                        titleColor: isValidAmount ? primaryColor : Colors.white,
                        titleSize: 13.sp,
                        buttonColor: greyLightColor,
                        borderColor:
                            isValidAmount ? primaryColor : Colors.white,
                        radius: 8.sp,
                        isBold: true,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
