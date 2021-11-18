import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class DeliveryRules extends StatefulWidget {
  const DeliveryRules({Key? key}) : super(key: key);

  @override
  _DeliveryRulesState createState() => _DeliveryRulesState();
}

class _DeliveryRulesState extends State<DeliveryRules> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onReadMore,
      child: Row(
        children: [
          SvgPicture.asset(errorOutlineIcon, color: dangerColor, width: 12.w),
          SizedBox(width: 4.w),
          Container(
            width: 150.w,
            child: Text(
              deliveryRule?.title ?? '',
              style: mediumTextStyle.copyWith(
                color: dangerColor,
                fontSize: 12.sp,
                overflow: TextOverflow.clip,
              ),
              maxLines: 1,
            ),
          ),
          Text(
            '...' + 'read_more'.tr(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  _onReadMore() {
    showSlidingBottomSheet(
      context,
      builder: (_) => SlidingSheetDialog(
        color: Colors.white,
        elevation: 2,
        cornerRadius: 15.sp,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.9],
          positioning: SnapPositioning.relativeToSheetHeight,
        ),
        minHeight: designHeight.h - 100.h,
        duration: Duration(milliseconds: 500),
        headerBuilder: (_, __) => DeliveryRulesDialogHeader(),
        builder: (context, state) {
          return DeliveryRulesDialog();
        },
      ),
    );
  }
}

class DeliveryRulesDialogHeader extends StatelessWidget {
  const DeliveryRulesDialogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Material(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Align(
            alignment: Preload.language == 'en' ? Alignment.topRight : Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.close, color: greyDarkColor, size: 25.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryRulesDialog extends StatelessWidget {
  const DeliveryRulesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deliveryRule?.title ?? '',
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Html(data: deliveryRule?.content),
          ],
        ),
      ),
    );
  }
}
