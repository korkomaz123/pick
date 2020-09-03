import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterColorSelect extends StatelessWidget {
  final List<String> items;
  final List<String> values;
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: pageStyle.unitWidth * 10,
      runSpacing: pageStyle.unitHeight * 4,
      children: items.map((item) {
        return InkWell(
          onTap: () => onTap(item),
          child: Container(
            width: values.contains(item) ? itemWidth * 1.2 : itemWidth,
            height: values.contains(item) ? itemHeight * 1.2 : itemHeight,
            decoration: BoxDecoration(
              color: colors[item],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
