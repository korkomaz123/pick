import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'search_basic_select.dart';

class SearchFilterOption extends StatefulWidget {
  final PageStyle pageStyle;
  final List<dynamic> categories;
  final List<dynamic> brands;
  final List<dynamic> genders;
  final dynamic selectedCategory;
  final dynamic selectedBrand;
  final Function onSelectCategory;
  final Function onSelectBrand;
  final Function onSelectGender;

  SearchFilterOption({
    this.pageStyle,
    this.categories,
    this.brands,
    this.genders,
    this.selectedCategory,
    this.selectedBrand,
    this.onSelectCategory,
    this.onSelectBrand,
    this.onSelectGender,
  });

  @override
  _SearchFilterOptionState createState() => _SearchFilterOptionState();
}

class _SearchFilterOptionState extends State<SearchFilterOption> {
  List<dynamic> categories;
  List<dynamic> brands;
  List<dynamic> genders;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    brands = widget.brands;
    genders = widget.genders;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.pageStyle.deviceWidth,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 20,
          vertical: widget.pageStyle.unitHeight * 30,
        ),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Text(
                      'bottom_category'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: widget.pageStyle.unitFontSize * 23,
                      ),
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: SearchBasicSelect(
                      pageStyle: widget.pageStyle,
                      width: double.infinity,
                      options: categories,
                      values: [widget.selectedCategory],
                      onSelectItem: (value) => widget.onSelectCategory(value),
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.pageStyle.unitHeight * 20),
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Text(
                      'brands_title'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: widget.pageStyle.unitFontSize * 23,
                      ),
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: SearchBasicSelect(
                      pageStyle: widget.pageStyle,
                      width: double.infinity,
                      options: brands,
                      values: [widget.selectedBrand],
                      onSelectItem: (value) => widget.onSelectBrand(value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
