import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'search_basic_select.dart';

class SearchFilterOption extends StatefulWidget {
  final List<dynamic> categories;
  final List<dynamic> brands;
  final List<dynamic> genders;
  final List<dynamic> selectedCategories;
  final List<dynamic> selectedBrands;
  final Function onSelectCategory;
  final Function onSelectBrand;
  final Function onSelectGender;

  SearchFilterOption({
    required this.categories,
    required this.brands,
    required this.genders,
    required this.selectedCategories,
    required this.selectedBrands,
    required this.onSelectCategory,
    required this.onSelectBrand,
    required this.onSelectGender,
  });

  @override
  _SearchFilterOptionState createState() => _SearchFilterOptionState();
}

class _SearchFilterOptionState extends State<SearchFilterOption> {
  List<dynamic>? categories;
  List<dynamic>? brands;
  List<dynamic>? genders;

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
        width: 375.w,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 30.h,
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
                        fontSize: 23.sp,
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
                      width: double.infinity,
                      options: categories!,
                      values: widget.selectedCategories,
                      onSelectItem: (value) => widget.onSelectCategory(value),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
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
                        fontSize: 23.sp,
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
                      width: double.infinity,
                      options: brands!,
                      values: widget.selectedBrands,
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
