import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SearchBasicSelect extends StatefulWidget {
  final PageStyle pageStyle;
  final double width;
  final List<dynamic> options;
  final List<dynamic> values;
  final Function onSelectItem;

  SearchBasicSelect({
    this.pageStyle,
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
                    color: isSelected
                        ? Colors.transparent
                        : greyDarkColor.withOpacity(0.3),
                  ),
                  color: isSelected ? primaryColor : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  item['label'],
                  style: bookTextStyle.copyWith(
                    color: isSelected ? Colors.white : greyDarkColor,
                    fontSize: widget.pageStyle.unitFontSize * 14,
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
