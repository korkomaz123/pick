import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterColorSelect extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> values;
  final Map<String, Color> colors;
  final double itemWidth;
  final double itemHeight;
  final Function onTap;

  FilterColorSelect({
    required this.items,
    required this.values,
    required this.colors,
    required this.itemWidth,
    required this.itemHeight,
    required this.onTap,
  });

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 4.h,
      children: items.map((item) {
        return InkWell(
          onTap: () => onTap(item),
          child: Container(
            width: values.contains(item['value']) ? itemWidth * 1.2 : itemWidth,
            height:
                values.contains(item['value']) ? itemHeight * 1.2 : itemHeight,
            decoration: BoxDecoration(
              color: _getColorFromHex(item['color_code']),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
