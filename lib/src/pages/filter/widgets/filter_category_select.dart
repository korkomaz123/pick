import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterCategorySelect extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> values;
  final double itemWidth;
  final double itemHeight;
  final Function onTap;

  FilterCategorySelect({
    required this.items,
    required this.values,
    required this.itemWidth,
    required this.itemHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 4.h,
      children: items.map((item) {
        return InkWell(
          onTap: () => onTap(item),
          child: Container(
            width: itemWidth,
            height: itemHeight,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: values.contains(item['value']) ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: values.contains(item['value']) ? Colors.transparent : primaryColor,
              ),
            ),
            child: Row(
              children: [
                values.contains(item['value'])
                    ? SvgPicture.asset(
                        item == items[0] ? bestDealIcon : newArrivalIcon,
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        item == items[0] ? bestDealIcon : newArrivalIcon,
                      ),
                SizedBox(width: 4.w),
                Text(
                  item['display'].toString().tr(),
                  style: mediumTextStyle.copyWith(
                    color: values.contains(item['value']) ? Colors.white : darkColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
