import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterColorSelect extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> values;
  final Map<String, Color> colors;
  final double itemWidth;
  final double itemHeight;
  final Function onTap;
  final PageStyle pageStyle;

  FilterColorSelect({
    this.items,
    this.values,
    this.colors,
    this.itemWidth,
    this.itemHeight,
    this.onTap,
    this.pageStyle,
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
      spacing: pageStyle.unitWidth * 10,
      runSpacing: pageStyle.unitHeight * 4,
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
