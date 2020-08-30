import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SearchFilterDialog extends StatefulWidget {
  final PageStyle pageStyle;

  SearchFilterDialog({this.pageStyle});

  @override
  _SearchFilterDialogState createState() => _SearchFilterDialogState();
}

class _SearchFilterDialogState extends State<SearchFilterDialog> {
  String category;
  String store;
  String gender;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.pageStyle.deviceWidth,
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 20,
          vertical: widget.pageStyle.unitHeight * 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: boldTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.pageStyle.unitHeight * 60,
              child: SelectOptionCustomCustom(
                items: List.generate(6, (index) => 'Category $index'),
                value: category,
                titleSize: widget.pageStyle.unitFontSize * 16,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 6,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade300,
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: Colors.transparent,
                selectedTitleColor: Colors.white,
                unSelectedTitleColor: greyColor,
                listStyle: true,
                isVertical: false,
                onTap: (value) => Navigator.pop(context, value),
              ),
            ),
            SizedBox(height: widget.pageStyle.unitHeight * 20),
            Text(
              'Stores',
              style: boldTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.pageStyle.unitHeight * 60,
              child: SelectOptionCustomCustom(
                items: List.generate(6, (index) => 'Store $index'),
                value: store,
                titleSize: widget.pageStyle.unitFontSize * 16,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 6,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade300,
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: Colors.transparent,
                selectedTitleColor: Colors.white,
                unSelectedTitleColor: greyColor,
                listStyle: true,
                isVertical: false,
                onTap: (value) => Navigator.pop(context, value),
              ),
            ),
            SizedBox(height: widget.pageStyle.unitHeight * 20),
            Text(
              'Gender',
              style: boldTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.pageStyle.unitHeight * 60,
              child: SelectOptionCustomCustom(
                items: List.generate(3, (index) => 'Gender $index'),
                value: gender,
                titleSize: widget.pageStyle.unitFontSize * 16,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 6,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade300,
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: Colors.transparent,
                selectedTitleColor: Colors.white,
                unSelectedTitleColor: greyColor,
                listStyle: true,
                isVertical: false,
                onTap: (value) => Navigator.pop(context, value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
