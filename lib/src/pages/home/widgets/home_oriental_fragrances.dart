import 'package:auto_size_text/auto_size_text.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_custom_vv_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
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

class HomeOrientalFragrances extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeOrientalFragrances({@required this.homeChangeNotifier});
  Widget build(BuildContext context) {
    if (homeChangeNotifier.orientalProducts.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(8.w),
        color: Colors.white,
        child: Column(
          children: [
            _buildHeadline(),
            FutureBuilder(
              future: homeChangeNotifier.loadExculisiveBanner(),
              builder: (_, snapShot) =>
                  snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: PulseLoadingSpinner())
                      : HomeExculisiveBanner(
                          homeChangeNotifier: homeChangeNotifier),
            ),
            _buildProductsList(homeChangeNotifier.orientalProducts),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              homeChangeNotifier.orientalTitle ?? '',
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
                  category: homeChangeNotifier.orientalCategory,
                  subCategory:
                      homeChangeNotifier.orientalCategory.subCategories,
                  brand: BrandEntity(),
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  Preload.navigatorKey.currentContext,
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
          ),
        ),
      ),
    );
  }
}
