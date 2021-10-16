// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

import '../../../../preload.dart';

class HomeGrooming extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeGrooming({required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.groomingTitle.isNotEmpty ||
        homeChangeNotifier.groomingCategories.isNotEmpty ||
        homeChangeNotifier.groomingItems.isNotEmpty) {
      return Container(
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            if (homeChangeNotifier.groomingTitle.isNotEmpty) ...[
              _buildHeadline()
            ],
            if (homeChangeNotifier.groomingCategories.isNotEmpty) ...[
              _buildCategories(homeChangeNotifier.groomingCategories)
            ],
            if (homeChangeNotifier.groomingItems.isNotEmpty) ...[
              _buildProducts(homeChangeNotifier.groomingItems)
            ],
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              homeChangeNotifier.groomingTitle,
              maxLines: 1,
              style: mediumTextStyle.copyWith(
                fontSize: 26.sp,
                color: greyDarkColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              borderWidth: Preload.language == 'en' ? 1 : 0.5,
              radius: 0,
              onPressed: () {
                ProductListArguments arguments = ProductListArguments(
                  category: homeChangeNotifier.groomingCategory,
                  subCategory: [],
                  brand: null,
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  Preload.navigatorKey!.currentContext!,
                  Routes.productList,
                  arguments: arguments,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<CategoryEntity> categories) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      height: 120.w * (1050 / 567),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            final arguments = ProductListArguments(
              category: categories[index],
              brand: null,
              subCategory: [],
              selectedSubCategoryIndex: 0,
              isFromBrand: false,
            );
            Navigator.pushNamed(
              Preload.navigatorKey!.currentContext!,
              Routes.productList,
              arguments: arguments,
            );
          },
          child: CachedNetworkImage(
            imageUrl: categories[index].imageUrl!,
            fit: BoxFit.fill,
            errorWidget: (context, url, error) =>
                Center(child: Icon(Icons.image, size: 20)),
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      height: 175.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.only(bottom: 3.h),
          child: ProductCard(
            cardWidth: 120.w,
            cardHeight: 175.w,
            product: list[index],
            isWishlist: true,
          ),
        ),
      ),
    );
  }
}
