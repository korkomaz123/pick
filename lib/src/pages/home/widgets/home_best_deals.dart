import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_v_card.dart';
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

class HomeBestDeals extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeBestDeals({@required this.model});

  @override
  _HomeBestDealsState createState() => _HomeBestDealsState();
}

class _HomeBestDealsState extends State<HomeBestDeals> {
  CategoryEntity bestDeals = homeCategories[0];
  List<ProductModel> bestDealsProducts;
  String title;
  HomeChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    bestDealsProducts = model.bestDealsProducts;
    title = model.bestDealsTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 380.h,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      child: Column(
        children: [
          _buildHeadline(),
          _buildProductsList(),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: 15.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              radius: 0,
              onPressed: () {
                ProductListArguments arguments = ProductListArguments(
                  category: homeCategories[0],
                  subCategory: homeCategories[0].subCategories,
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

  Widget _buildProductsList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bestDealsProducts.map((item) {
            return Container(
              margin: EdgeInsets.only(left: 5.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.w,
                ),
              ),
              child: ProductVCard(
                cardWidth: 170.w,
                cardHeight: 280.h,
                product: item,
                isShoppingCart: true,
                isLine: true,
                isMinor: true,
                isWishlist: true,
                isShare: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
