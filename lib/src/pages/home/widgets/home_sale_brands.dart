import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';

import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import 'home_loading_widget.dart';

class HomeSaleBrands extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeSaleBrands({required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.saleBrands.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Text(
                homeChangeNotifier.saleBrandsTitle,
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
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: List.generate(
                    homeChangeNotifier.saleBrands.length,
                    (itemIndex) => _buildSaleBrandCard(itemIndex),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }

  Widget _buildSaleBrandCard(int itemIndex) {
    return InkWell(
      onTap: () {
        final arguments = ProductListArguments(
          category: null,
          brand: homeChangeNotifier.saleBrands[itemIndex],
          subCategory: [],
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(
          Preload.navigatorKey!.currentContext!,
          Routes.productList,
          arguments: arguments,
        );
      },
      child: Container(
        width: 120.w,
        height: 126.w,
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
                  key: ValueKey(
                      homeChangeNotifier.saleBrands[itemIndex].brandImage ??
                          ''),
                  cacheKey:
                      homeChangeNotifier.saleBrands[itemIndex].brandImage ?? '',
                  imageUrl:
                      homeChangeNotifier.saleBrands[itemIndex].brandImage ?? '',
                  width: 110.w,
                  height: 110.w,
                  errorWidget: (_, __, ___) =>
                      Center(child: Icon(Icons.image, size: 20)),
                  progressIndicatorBuilder: (_, __, ___) {
                    return CachedNetworkImage(
                      key: ValueKey(homeChangeNotifier
                              .saleBrands[itemIndex].brandThumbnail ??
                          ''),
                      cacheKey: homeChangeNotifier
                              .saleBrands[itemIndex].brandThumbnail ??
                          '',
                      width: 110.w,
                      height: 110.w,
                      imageUrl: homeChangeNotifier
                              .saleBrands[itemIndex].brandThumbnail ??
                          '',
                      errorWidget: (_, __, ___) =>
                          Center(child: Icon(Icons.image, size: 20)),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'discount'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 8.sp,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'up_to'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 8.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${homeChangeNotifier.saleBrands[itemIndex].percentage}%',
                      style: mediumTextStyle.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
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
