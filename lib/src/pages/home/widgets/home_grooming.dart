import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeGrooming extends StatefulWidget {
  @override
  _HomeGroomingState createState() => _HomeGroomingState();
}

class _HomeGroomingState extends State<HomeGrooming> {
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              if (model.groomingTitle.isNotEmpty) ...[
                _buildTitle(model.groomingTitle)
              ],
              if (model.groomingCategories.isNotEmpty) ...[
                _buildCategories(model.groomingCategories)
              ],
              if (model.groomingItems.isNotEmpty) ...[
                _buildProducts(model.groomingItems)
              ],
              if (model.groomingCategory != null) ...[
                _buildFooter(model.groomingCategory, model.groomingTitle)
              ],
            ],
          ),
        );
      },
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
        style: mediumTextStyle.copyWith(
          fontSize: 26.sp,
        ),
      ),
    );
  }

  Widget _buildCategories(List<CategoryEntity> categories) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return InkWell(
              onTap: () {
                if (category?.id != null) {
                  final arguments = ProductListArguments(
                    category: category,
                    brand: BrandEntity(),
                    subCategory: [],
                    selectedSubCategoryIndex: 0,
                    isFromBrand: false,
                  );
                  Navigator.pushNamed(
                    context,
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(
                    10.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.h),
      color: backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            int index = list.indexOf(item);
            return Container(
              padding: EdgeInsets.only(
                left: index > 0 ? 2.w : 0,
                bottom: 3.h,
              ),
              child: ProductCard(
                cardWidth: 120.w,
                cardHeight: 175.w,
                product: item,
                isWishlist: true,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 10.w,
      ),
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
            context,
            Routes.productList,
            arguments: arguments,
          );
        },
        title: 'view_all_grooming'.tr(),
        titleColor: Colors.white,
        titleSize: 18.sp,
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 24.sp,
        ),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }
}
