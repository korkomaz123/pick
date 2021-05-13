import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectBlockListDialog extends StatefulWidget {
  final String value;

  SelectBlockListDialog({this.value});

  @override
  _SelectBlockListDialogState createState() => _SelectBlockListDialogState();
}

class _SelectBlockListDialogState extends State<SelectBlockListDialog> {
  String value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: greyLightColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 20.h,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((item) {
            bool isSelected = item.toString() == value;
            return Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context, item.toString()),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$item',
                          style: mediumTextStyle.copyWith(
                            fontSize: 14.sp,
                            color:
                                isSelected ? primarySwatchColor : greyDarkColor,
                          ),
                        ),
                        if (isSelected) ...[
                          Icon(
                            Icons.check,
                            size: 18.sp,
                            color: primarySwatchColor,
                          )
                        ],
                      ],
                    ),
                  ),
                ),
                if (item < 10) ...[Divider(color: greyColor)],
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
