import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_vv_card.dart';
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

class HomeOrientalFragrances extends StatefulWidget {
  @override
  _HomeOrientalFragrancesState createState() => _HomeOrientalFragrancesState();
}

class _HomeOrientalFragrancesState extends State<HomeOrientalFragrances> {
  String title;
  CategoryEntity orientalCategory;
  List<ProductModel> orientalProducts;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 410.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(8.w),
      color: Colors.white,
      child: Consumer<HomeChangeNotifier>(
        builder: (_, model, __) {
          orientalProducts = model.orientalProducts;
          title = model.orientalTitle;
          orientalCategory = model.orientalCategory;
          if (orientalProducts.isNotEmpty) {
            return Column(
              children: [
                _buildHeadline(),
                _buildProductsList(model.orientalProducts),
              ],
            );
          } else {
            return Container();
          }
        },
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
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
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
                  category: orientalCategory,
                  subCategory: orientalCategory.subCategories,
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

  Widget _buildProductsList(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 10.h,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Container(
              margin: EdgeInsets.only(left: 5.w),
              child: ProductVVCard(
                cardWidth: 170.w,
                cardHeight: 330.h,
                product: item,
                isShoppingCart: true,
                isLine: false,
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
