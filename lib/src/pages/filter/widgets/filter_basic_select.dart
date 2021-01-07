import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterBasicSelect extends StatefulWidget {
  final PageStyle pageStyle;
  final double width;
  final List<dynamic> options;
  final List<dynamic> values;
  final Function onSelectItem;

  FilterBasicSelect({
    this.pageStyle,
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
                margin: EdgeInsets.symmetric(
                  horizontal: widget.pageStyle.unitWidth * 4,
                  vertical: widget.pageStyle.unitHeight * 5,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.pageStyle.unitWidth * 20,
                  vertical: widget.pageStyle.unitHeight * 3,
                ),
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
                    fontSize: widget.pageStyle.unitFontSize * 12,
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
