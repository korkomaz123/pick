import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_loading_widget.dart';

class HomeShopByCategory extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeShopByCategory({required this.homeChangeNotifier});

  @override
  _HomeShopByCategoryState createState() => _HomeShopByCategoryState();
}

class _HomeShopByCategoryState extends State<HomeShopByCategory> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.categories.isNotEmpty) {
      return Container(
        width: designWidth.w,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Text(
                'shop_by_categories'.tr(),
                maxLines: 1,
                style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 26.sp),
              ),
            ),
            _buildCategoryList(),
            Container(
              width: 375.w,
              height: 45.h,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: MarkaaTextButton(
                title: 'see_all_categories'.tr(),
                titleSize: 20.sp,
                titleColor: Colors.white,
                buttonColor: primarySwatchColor,
                borderColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.categoryList);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return HomeLoadingWidget();
    }
  }

  Widget _buildCategoryList() {
    return Container(
      width: designWidth.w,
      height: 300.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 10.h,
        children: widget.homeChangeNotifier.categories.getRange(0, 6).map((category) {
          return Column(
            children: [
              CachedNetworkImage(
                imageUrl: category.imageUrl ?? '',
                imageBuilder: (context, imageProvider) {
                  return InkWell(
                    onTap: () {
                      ProductListArguments arguments = ProductListArguments(
                        category: category,
                        subCategory: [],
                        brand: null,
                        selectedSubCategoryIndex: 0,
                        isFromBrand: false,
                      );
                      Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                    },
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 5.h),
              Text(category.name, style: TextStyle(color: Colors.black, fontSize: 14.sp)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
