import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class HomeSaleBrands extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeSaleBrands({this.homeChangeNotifier});

  @override
  _HomeSaleBrandsState createState() => _HomeSaleBrandsState();
}

class _HomeSaleBrandsState extends State<HomeSaleBrands> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.saleBrands.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Text(
                'brands_on_sale'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 26.sp,
                  color: darkColor,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: List.generate(
                    widget.homeChangeNotifier.saleBrands.length,
                    (itemIndex) => _buildSaleBrandCard(itemIndex),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildSaleBrandCard(int itemIndex) {
    return InkWell(
      onTap: () {
        final arguments = ProductListArguments(
          category: CategoryEntity(),
          brand: widget.homeChangeNotifier.saleBrands[itemIndex],
          subCategory: [],
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(
          context,
          Routes.productList,
          arguments: arguments,
        );
      },
      child: Container(
        width: 120.w,
        height: 130.w,
        child: Stack(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
              elevation: 4,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget
                      .homeChangeNotifier.saleBrands[itemIndex].brandImage,
                  width: 110.w,
                  height: 110.w,
                  progressIndicatorBuilder: (_, __, ___) {
                    return CachedNetworkImage(
                      width: 110.w,
                      height: 110.w,
                      imageUrl: widget.homeChangeNotifier.saleBrands[itemIndex]
                          .brandThumbnail,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: dangerColor,
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.homeChangeNotifier.saleBrands[itemIndex].percentage}%',
                      style: mediumTextStyle.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'up_to'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 8.sp,
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          'off'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 8.sp,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}