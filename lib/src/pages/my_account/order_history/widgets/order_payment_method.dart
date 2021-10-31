import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/icons.dart';

class OrderPaymentMethod extends StatelessWidget {
  final String paymentMethod;

  OrderPaymentMethod({required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    if (paymentMethod == 'cashondelivery') {
      return SvgPicture.asset(
        'lib/public/icons/cashondelivery.svg',
        height: 20.h,
        width: 30.w,
      );
    } else if (paymentMethod == 'knet') {
      return SvgPicture.asset(
        'lib/public/icons/knet.svg',
        height: 20.h,
        width: 30.w,
      );
    } else if (paymentMethod == 'tap') {
      return Row(
        children: [
          Image.asset(
            'lib/public/images/visa-card.png',
            height: 20.h,
            width: 50.w,
          ),
          SizedBox(
            width: 3.w,
          ),
          SvgPicture.asset(
            'lib/public/icons/line.svg',
            height: 20.h,
            width: 7.w,
          ),
          SizedBox(
            width: 5.w,
          ),
          SvgPicture.asset(
            'lib/public/icons/master-card.svg',
            height: 20.h,
            width: 36.w,
          ),
        ],
      );
    } else {
      return SvgPicture.asset(walletIcon, width: 27.w, height: 20.h);
    }
  }
}
