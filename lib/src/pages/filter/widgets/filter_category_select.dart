import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterCategorySelect extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> values;
  final double itemWidth;
  final double itemHeight;
  final Function onTap;
  final PageStyle pageStyle;

  FilterCategorySelect({
    this.items,
    this.values,
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
            width: itemWidth,
            height: itemHeight,
            padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 5),
            decoration: BoxDecoration(
              color:
                  values.contains(item['value']) ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: values.contains(item['value'])
                    ? Colors.transparent
                    : primaryColor,
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
                SizedBox(width: pageStyle.unitWidth * 4),
                Text(
                  item['display'].toString().tr(),
                  style: mediumTextStyle.copyWith(
                    color: values.contains(item['value'])
                        ? Colors.white
                        : primaryColor,
                    fontSize: pageStyle.unitFontSize * 16,
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
