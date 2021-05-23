import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBasicSelect extends StatefulWidget {
  final double width;
  final List<dynamic> options;
  final List<dynamic> values;
  final Function onSelectItem;

  SearchBasicSelect({
    this.width,
    this.options,
    this.values,
    this.onSelectItem,
  });

  @override
  _SearchBasicSelectState createState() => _SearchBasicSelectState();
}

class _SearchBasicSelectState extends State<SearchBasicSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.options.map((item) {
            int index = widget.values.indexOf(item['value']);
            bool isSelected = index >= 0;
            return InkWell(
              onTap: () => widget.onSelectItem(item),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 5.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : greyDarkColor.withOpacity(0.3),
                  ),
                  color: isSelected ? primaryColor : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  item['label'],
                  style: mediumTextStyle.copyWith(
                    color: isSelected ? Colors.white : greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
