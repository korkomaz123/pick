import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'home_products_carousel.dart';

class HomeNewArrivals extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeNewArrivals({@required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.newArrivalsProducts.isNotEmpty) {
      return Column(
        children: [
          _buildHeadline(),
          HomeProductsCarousel(
            products: homeChangeNotifier.newArrivalsProducts,
            isVerticalCard: false,
          ),
          Divider(
            height: 4.h,
            thickness: 1.5.h,
            color: greyColor.withOpacity(0.4),
          ),
          _buildFooter(context),
        ],
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
          Text(
            homeChangeNotifier.newArrivalsTitle ?? '',
            style: mediumTextStyle.copyWith(
              fontSize: 26.sp,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_all'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 15.sp,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
