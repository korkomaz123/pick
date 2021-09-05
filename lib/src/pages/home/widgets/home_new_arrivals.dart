import 'package:auto_size_text/auto_size_text.dart';
import 'package:markaa/preload.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_products_carousel.dart';

class HomeNewArrivals extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeNewArrivals({@required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.newArrivalsProducts.isNotEmpty) {
      return Consumer<HomeChangeNotifier>(builder: (_, __, ___) {
        return Container(
          height: 240.h,
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.only(bottom: 10.h),
          color: Colors.white,
          child: Column(
            children: [
              _buildHeadline(context),
              HomeProductsCarousel(
                products: homeChangeNotifier.newArrivalsProducts,
                isVerticalCard: false,
                onAddToCartFailure: homeChangeNotifier.updateNewArrivalsProduct,
              ),
            ],
          ),
        );
      });
    } else {
      return Container();
    }
  }

  Widget _buildHeadline(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              homeChangeNotifier.newArrivalsTitle ?? '',
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
              onPressed: () async {
                ProductListArguments arguments = ProductListArguments(
                  category: homeCategories[1],
                  subCategory: homeCategories[1].subCategories,
                  brand: BrandEntity(),
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  context,
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
}
