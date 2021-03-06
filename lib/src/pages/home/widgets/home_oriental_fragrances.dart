import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_custom_vv_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../preload.dart';
import 'home_exculisive_banner.dart';
import 'home_loading_widget.dart';

class HomeOrientalFragrances extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeOrientalFragrances({required this.homeChangeNotifier});

  Widget build(BuildContext context) {
    if (homeChangeNotifier.orientalProducts.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(vertical: 8.w),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: _buildHeadline(),
            ),
            HomeExculisiveBanner(homeChangeNotifier: homeChangeNotifier),
            _buildProductsList(homeChangeNotifier.orientalProducts),
          ],
        ),
      );
    } else {
      return HomeLoadingWidget();
    }
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Text(
              homeChangeNotifier.orientalTitle,
              maxLines: 1,
              style: mediumTextStyle.copyWith(fontSize: 26.sp, color: greyDarkColor),
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
                ProductListArguments arguments = ProductListArguments(
                  category: homeChangeNotifier.orientalCategory,
                  subCategory: homeChangeNotifier.orientalCategory!.subCategories,
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

  Widget _buildProductsList(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      height: 300.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: 5.w),
          child: ProductCustomVVCard(
            cardWidth: 170.w,
            cardHeight: 280.h,
            product: list[index],
            isShoppingCart: true,
            isLine: false,
            isMinor: true,
            isWishlist: true,
            isShare: false,
            borderRadius: 10.sp,
            onAddToCartFailure: () => homeChangeNotifier.updateOrientalProduct(index),
          ),
        ),
      ),
    );
  }
}
