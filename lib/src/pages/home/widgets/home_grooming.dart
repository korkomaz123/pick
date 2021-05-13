import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
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
  HomeGrooming({@required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: designWidth.w,
      color: Colors.white,
      child: Column(
        children: [
          if (homeChangeNotifier.groomingTitle.isNotEmpty) ...[
            _buildTitle(homeChangeNotifier.groomingTitle)
          ],
          if (homeChangeNotifier.groomingCategories.isNotEmpty) ...[
            _buildCategories(homeChangeNotifier.groomingCategories)
          ],
          if (homeChangeNotifier.groomingItems.isNotEmpty) ...[
            _buildProducts(homeChangeNotifier.groomingItems)
          ],
          if (homeChangeNotifier.groomingCategory != null) ...[
            _buildFooter(
              homeChangeNotifier.groomingCategory,
              homeChangeNotifier.groomingTitle,
            )
          ],
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(fontSize: 26.sp),
      ),
    );
  }

  Widget _buildCategories(List<CategoryEntity> categories) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      height: 276.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            if (categories[index]?.id != null) {
              final arguments = ProductListArguments(
                category: categories[index],
                brand: BrandEntity(),
                subCategory: [],
                selectedSubCategoryIndex: 0,
                isFromBrand: false,
              );
              Navigator.pushNamed(
                Preload.navigatorKey.currentContext,
                Routes.productList,
                arguments: arguments,
              );
            }
          },
          child: Container(
            width: 151.w,
            height: 276.h,
            margin: EdgeInsets.only(right: 5.w),
            padding: EdgeInsets.only(bottom: 10.h),
            child: CachedNetworkImage(
              imageUrl: categories[index].imageUrl,
              fit: BoxFit.fill,
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.h),
      color: backgroundColor,
      height: 175.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.only(
            left: (index.w > 0 ? 2 : 0),
            bottom: 3.h,
          ),
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

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: category,
            subCategory: [],
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
        title: 'view_all_grooming'.tr(),
        titleColor: Colors.white,
        titleSize: 18.sp,
        icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24.sp),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }
}
