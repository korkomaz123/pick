import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import 'payment_method_card.dart';

class PaymentMethodList extends StatefulWidget {
  final String value;
  final Function(String?)? onChangeMethod;

  PaymentMethodList({
    required this.value,
    this.onChangeMethod,
  });

  @override
  _PaymentMethodListState createState() => _PaymentMethodListState();
}

class _PaymentMethodListState extends State<PaymentMethodList> {
  var details;

  @override
  void initState() {
    details = orderDetails['orderDetails'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'order_payment_method'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            children: List.generate(paymentMethods.length, (index) {
              int idx = paymentMethods.length - index - 1;
              if ((user == null || user!.balance <= 0) &&
                  paymentMethods[idx].id == 'wallet') {
                return Container();
              }
              return PaymentMethodCard(
                method: paymentMethods[idx],
                onChangeMethod: widget.onChangeMethod,
                value: widget.value,
              );
            }),
          ),
        ],
      ),
    );
  }
}
