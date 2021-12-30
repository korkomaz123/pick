import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/theme/icons.dart';
// import 'package:markaa/src/theme/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:markaa/src/theme/theme.dart';

class MarkaaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: SvgPicture.asset(markaaCustomIcon, width: 30.w),
      ),
    );
    // return Material(
    //   color: Colors.black.withOpacity(0.3),
    //   child: Dialog(
    //     backgroundColor: primarySwatchColor,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               SvgPicture.asset(markaaCustomIcon),
    //               Expanded(
    //                 child: Padding(
    //                   padding: EdgeInsetsDirectional.only(start: 30.w),
    //                   child: Text(
    //                     'please_wait'.tr(),
    //                     style: mediumTextStyle.copyWith(
    //                       fontSize: 18.sp,
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
