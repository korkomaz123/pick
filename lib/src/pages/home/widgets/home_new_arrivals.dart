import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_products_carousel.dart';

class HomeNewArrivals extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeNewArrivals({this.model});

  @override
  _HomeNewArrivalsState createState() => _HomeNewArrivalsState();
}

class _HomeNewArrivalsState extends State<HomeNewArrivals> {
  CategoryEntity newArrivals = homeCategories[1];
  List<ProductModel> newArrivalsProducts;
  String title;
  HomeChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    newArrivalsProducts = model.newArrivalsProducts;
    title = model.newArrivalsTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 300.h,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      child: Column(
        children: [
          _buildHeadline(),
          HomeProductsCarousel(
            products: newArrivalsProducts,
            isVerticalCard: false,
          ),
          Divider(
            height: 4.h,
            thickness: 1.5.h,
            color: greyColor.withOpacity(0.4),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
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
