import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../preload.dart';
import 'home_loading_widget.dart';

class HomeBestDeals extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeBestDeals({required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.bestDealsProducts.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        child: Column(
          children: [_buildHeadline(), _buildProductsList()],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              homeChangeNotifier.bestDealsTitle,
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
                  category: homeCategories[0],
                  subCategory: homeCategories[0].subCategories,
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

  Widget _buildProductsList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            homeChangeNotifier.bestDealsProducts.length,
            (index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 0.5.w),
                ),
                child: ProductVCard(
                  cardWidth: 170.w,
                  cardHeight: 280.h,
                  product: homeChangeNotifier.bestDealsProducts[index],
                  isShoppingCart: true,
                  isLine: true,
                  isMinor: true,
                  isWishlist: true,
                  isShare: false,
                  onAddToCartFailure: () => homeChangeNotifier.updateBestDealProduct(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
