import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SearchFilterDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  final List<dynamic> genders;

  SearchFilterDialog({
    this.pageStyle,
    this.categories,
    this.brands,
    this.genders,
  });

  @override
  _SearchFilterDialogState createState() => _SearchFilterDialogState();
}

class _SearchFilterDialogState extends State<SearchFilterDialog> {
  String category;
  String store;
  String gender;

  List<CategoryEntity> categories;
  List<BrandEntity> brands;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    brands = widget.brands;
  }

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
              'bottom_category'.tr(),
              style: boldTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.pageStyle.unitHeight * 60,
              child: SelectOptionCustomCustom(
                items: List.generate(
                  categories.length,
                  (index) => categories[index].name,
                ),
                value: category,
                titleSize: widget.pageStyle.unitFontSize * 14,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 10,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade200,
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
              'brands_title'.tr(),
              style: boldTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
            Container(
              width: double.infinity,
              height: widget.pageStyle.unitHeight * 60,
              child: SelectOptionCustomCustom(
                items: List.generate(
                  brands.length,
                  (index) => brands[index].brandLabel,
                ),
                value: store,
                titleSize: widget.pageStyle.unitFontSize * 14,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 10,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade200,
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
              'filter_gender'.tr(),
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
                titleSize: widget.pageStyle.unitFontSize * 14,
                itemSpace: widget.pageStyle.unitWidth * 0,
                radius: widget.pageStyle.unitWidth * 10,
                selectedColor: primaryColor,
                unSelectedColor: Colors.grey.shade200,
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
