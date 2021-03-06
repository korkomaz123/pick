import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/pages/my_wallet/checkout/my_wallet_checkout_page.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:string_validator/string_validator.dart';

class MyWalletDetailsForm extends StatefulWidget {
  final double? amount;

  MyWalletDetailsForm({this.amount});

  @override
  _MyWalletDetailsFormState createState() => _MyWalletDetailsFormState();
}

class _MyWalletDetailsFormState extends State<MyWalletDetailsForm> {
  final _amountController = TextEditingController();

  late MarkaaAppChangeNotifier _markaaAppChangeNotifier;
  late WalletChangeNotifier _walletChangeNotifier;

  late ProgressService _progressService;
  late FlushBarService _flushBarService;

  bool isValidAmount = false;

  @override
  void initState() {
    super.initState();

    _walletChangeNotifier = context.read<WalletChangeNotifier>();
    _markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();

    _progressService = ProgressService(context: context);
    _flushBarService = FlushBarService(context: context);

    _amountController.addListener(_onChangeAmount);
    if (widget.amount != null) {
      _amountController.text = widget.amount.toString();
    }
  }

  void _onChangeAmount() {
    String value = _amountController.text;
    if (value.isNotEmpty &&
        (isInt(value) || isFloat(value)) &&
        (double.parse(value) >= (widget.amount ?? 0))) {
      isValidAmount = true;
    } else {
      isValidAmount = false;
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _markaaAppChangeNotifier.rebuild();
    });
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
              height: 43.h,
              child: TextFormField(
                controller: _amountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 3,
                buildCounter: (
                  BuildContext context, {
                  int? currentLength,
                  int? maxLength,
                  bool? isFocused,
                }) =>
                    null,
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
            ),
            Consumer<MarkaaAppChangeNotifier>(
              builder: (_, __, ___) {
                return Column(
                  children: [
                    SizedBox(height: 25.h),
                    Container(
                      width: 168.w,
                      height: 38.h,
                      child: MarkaaTextButton(
                        onPressed: _onAddMoney,
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
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onAddMoney() {
    if (isValidAmount) {
      if (double.parse(_amountController.text) > 300) {
        String title = 'top_up_failed_title'.tr();
        String message = 'top_up_failed_message'.tr().replaceFirst('#', '300');
        _flushBarService.showErrorCustomDialog(title, message);
      } else {
        _walletChangeNotifier.createWalletCart(
          amount: _amountController.text,
          onProcess: _onCreatingWalletCart,
          onSuccess: _onCreatedWalletCartSuccess,
          onFailure: _onCreatedWalletCartFailure,
        );
      }
    }
  }

  void _onCreatingWalletCart() {
    _progressService.showProgress();
  }

  void _onCreatedWalletCartFailure(String message) {
    _progressService.hideProgress();
    _flushBarService.showErrorDialog(message);
  }

  void _onCreatedWalletCartSuccess() {
    _walletChangeNotifier.addMoneyToWallet(
      amount: _amountController.text,
      lang: Preload.language,
      onSuccess: _onAddedMoneySuccess,
      onFailure: _onAddedMoneyFailure,
    );
  }

  void _onAddedMoneySuccess() {
    _progressService.hideProgress();
    showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 10.sp,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          minHeight: designHeight.h - 100.h,
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return MyWalletCheckoutPage(fromCheckout: widget.amount != null);
          },
        );
      },
    );
  }

  void _onAddedMoneyFailure() {
    _progressService.hideProgress();
    _flushBarService.showErrorDialog('added_money_wallet_failed'.tr());
  }
}
