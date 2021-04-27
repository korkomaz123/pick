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

import '../../../../config.dart';

class HomeOrientalFragrances extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeOrientalFragrances({@required this.homeChangeNotifier});
  Widget build(BuildContext context) {
    if (homeChangeNotifier.orientalProducts.isNotEmpty) {
      return Column(
        children: [
          _buildHeadline(),
          Expanded(child: _buildProductsList(homeChangeNotifier.orientalProducts)),
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
            homeChangeNotifier.orientalTitle ?? '',
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 26,
              color: greyDarkColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Config.pageStyle.unitWidth * 5,
            ),
            height: Config.pageStyle.unitHeight * 30,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Config.pageStyle.unitFontSize * 15,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              radius: 0,
              onPressed: () {
                ProductListArguments arguments = ProductListArguments(
                  category: homeChangeNotifier.orientalCategory,
                  subCategory: homeChangeNotifier.orientalCategory.subCategories,
                  brand: BrandEntity(),
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  Config.navigatorKey.currentContext,
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
    return ListView.builder(
      padding: EdgeInsets.only(top: Config.pageStyle.unitHeight * 10),
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(left: Config.pageStyle.unitWidth * 5),
        child: ProductVVCard(
          cardWidth: Config.pageStyle.unitWidth * 170,
          cardHeight: Config.pageStyle.unitHeight * 325,
          product: list[index],
          isShoppingCart: true,
          isLine: false,
          isMinor: true,
          isWishlist: true,
          isShare: false,
        ),
      ),
    );
  }
}
