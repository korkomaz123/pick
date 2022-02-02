import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_loading_widget.dart';

class HomeDiscoverStores extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeDiscoverStores({required this.homeChangeNotifier});

  @override
  _HomeDiscoverStoresState createState() => _HomeDiscoverStoresState();
}

class _HomeDiscoverStoresState extends State<HomeDiscoverStores> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.brandList.isNotEmpty) {
      return Container(
        height: 60.h + 375.w,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildStoresSlider(),
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'brands_title'.tr(),
              maxLines: 1,
              style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 26.sp),
            ),
          ),
          Container(
            width: 80.w,
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Preload.language == 'en' ? 14.sp : 12.sp,
              titleColor: Colors.white,
              buttonColor: primarySwatchColor,
              borderColor: Colors.transparent,
              borderWidth: Preload.language == 'en' ? 1 : 0.5,
              radius: 0,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.brandList,
                  arguments: widget.homeChangeNotifier.brandList,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresSlider() {
    int length = widget.homeChangeNotifier.brandList.length;
    int randomIndex = length > 9 ? Random().nextInt(length - 9) : 0;
    return Expanded(
      child: Container(
        width: designWidth.w,
        height: 375.w,
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 7.5.w,
            runSpacing: 7.5.w,
            children: widget.homeChangeNotifier.brandList.sublist(randomIndex, randomIndex + 9).map((brand) {
              return InkWell(
                onTap: () {
                  ProductListArguments arguments = ProductListArguments(
                    category: null,
                    subCategory: [],
                    brand: brand,
                    selectedSubCategoryIndex: 0,
                    isFromBrand: true,
                  );
                  Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                },
                child: Container(
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: brand.brandImage ?? '',
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    progressIndicatorBuilder: (_, __, ___) {
                      return CachedNetworkImage(
                        imageUrl: brand.brandThumbnail ?? '',
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.contain,
                        errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
