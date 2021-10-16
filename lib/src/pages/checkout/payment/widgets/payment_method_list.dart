import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/preload.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';

import 'payment_method_card.dart';

class PaymentMethodList extends StatefulWidget {
  final String value;
  final SheetController controller;

  PaymentMethodList({required this.value, required this.controller});

  @override
  _PaymentMethodListState createState() => _PaymentMethodListState();
}

class _PaymentMethodListState extends State<PaymentMethodList> {
  FlushBarService? _flushBarService;
  var details;
  String? value;

  bool get outOfBalance => double.parse(details['totalPrice']) > user!.balance;

  @override
  void initState() {
    value = widget.value;
    details = orderDetails['orderDetails'];
    _onLoadUser();

    super.initState();
    _flushBarService = FlushBarService(context: context);
  }

  _onLoadUser() async {
    user = await Preload.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_payment_method'.tr(),
                  style: mediumTextStyle.copyWith(fontSize: 20.sp),
                ),
                IconButton(
                  icon: SvgPicture.asset(closeIcon),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Column(
              children: List.generate(paymentMethods.length, (index) {
                int idx = paymentMethods.length - index - 1;
                if (user!.balance <= 0 && paymentMethods[idx].id == 'wallet') {
                  return Container();
                }
                return PaymentMethodCard(
                  method: paymentMethods[idx],
                  onActiveChange: _onChangeMethod,
                  value: value!,
                  cardToken: null,
                  onAuthorizedSuccess: (token) {
                    Navigator.pop(
                      context,
                      {'method': 'tap', 'cardToken': token},
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeMethod(String? val) async {
    value = val;
    if (value == 'wallet' && outOfBalance) {
      final result = await _flushBarService!.showConfirmDialog(
        title: 'sorry',
        message: 'not_enough_balance',
        yesButtonText: 'add_button_title',
        noButtonText: 'cancel_button_title',
      );
      if (result != null) {
        double amount = double.parse(details['subTotalPrice']) - user!.balance;
        double value = NumericService.roundDouble(amount, 3);
        await Navigator.pushNamed(context, Routes.myWallet, arguments: value);
        setState(() {});
      }
    } else if (value != 'tap') {
      Navigator.pop(context, {'method': value, 'cardToken': null});
    } else {
      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await widget.controller.expand();
      });
    }
  }
}
