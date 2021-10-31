import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class DeliverAsGift extends StatefulWidget {
  const DeliverAsGift({Key? key}) : super(key: key);

  @override
  _DeliverAsGiftState createState() => _DeliverAsGiftState();
}

class _DeliverAsGiftState extends State<DeliverAsGift> {
  bool deliverAsGift = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
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
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: deliverAsGift,
              onChanged: (value) async {
                deliverAsGift = value;
                if (deliverAsGift) await _onSendAsGift();
              },
              activeColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future _onSendAsGift() async {
    final result = await showSlidingBottomSheet(
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
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return Container();
            // return DeliverAsGiftForm();
          },
        );
      },
    );
    if (result != null) {
      orderDetails['deliver_as_gift'] = result;
    } else {
      deliverAsGift = false;
      orderDetails['deliver_as_gift'] = {
        'deliver_as_gift': '0',
        'sender': '',
        'receiver': '',
        'message': '',
      };
    }
  }
}
