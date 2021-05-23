import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterBasicSelect extends StatefulWidget {
  final double width;
  final List<dynamic> options;
  final List<dynamic> values;
  final Function onSelectItem;

  FilterBasicSelect({
    this.width,
    this.options,
    this.values,
    this.onSelectItem,
  });

  @override
  _FilterBasicSelectState createState() => _FilterBasicSelectState();
}

class _FilterBasicSelectState extends State<FilterBasicSelect> {
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
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : primaryColor,
                  ),
                  color: isSelected ? primaryColor : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  item['display'].toString().toUpperCase(),
                  style: mediumTextStyle.copyWith(
                    color: isSelected ? Colors.white : primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
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
