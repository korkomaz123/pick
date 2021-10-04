import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSortByDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 375.w,
        color: Color(0xFFE9E9E9),
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          children: [
            Container(
              width: 375.w,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              alignment: Alignment.center,
              child: Text(
                "sort".tr(),
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 26.sp,
                ),
              ),
            ),
            Divider(
              thickness: 0.8,
              color: greyColor.withOpacity(0.6),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                sortByList.length,
                (index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context, sortByList[index]),
                        child: Container(
                          width: 375.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sortByList[index].tr(),
                            textAlign: TextAlign.center,
                            style: mediumTextStyle.copyWith(
                              color: primaryColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.8,
                        color: greyColor.withOpacity(0.6),
                      )
                    ],
                  );
                },
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context, 'default'),
              child: Container(
                width: 375.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                alignment: Alignment.center,
                child: Text(
                  'default'.tr(),
                  textAlign: TextAlign.center,
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
