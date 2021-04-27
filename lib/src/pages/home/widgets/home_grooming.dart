import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

import '../../../../config.dart';

class HomeGrooming extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeGrooming({@required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Config.pageStyle.deviceWidth,
      color: Colors.white,
      child: Column(
        children: [
          if (homeChangeNotifier.groomingTitle.isNotEmpty) ...[_buildTitle(homeChangeNotifier.groomingTitle)],
          if (homeChangeNotifier.groomingCategories.isNotEmpty) ...[_buildCategories(homeChangeNotifier.groomingCategories)],
          if (homeChangeNotifier.groomingItems.isNotEmpty) ...[_buildProducts(homeChangeNotifier.groomingItems)],
          if (homeChangeNotifier.groomingCategory != null) ...[_buildFooter(homeChangeNotifier.groomingCategory, homeChangeNotifier.groomingTitle)],
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Config.pageStyle.unitWidth * 10, vertical: Config.pageStyle.unitHeight * 10),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(fontSize: Config.pageStyle.unitFontSize * 26),
      ),
    );
  }

  Widget _buildCategories(List<CategoryEntity> categories) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 10),
      height: Config.pageStyle.unitHeight * 276,
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
              Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
            }
          },
          child: Container(
            width: Config.pageStyle.unitWidth * 151,
            height: Config.pageStyle.unitHeight * 276,
            margin: EdgeInsets.only(right: Config.pageStyle.unitWidth * 5),
            padding: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
            child: CachedNetworkImage(
              imageUrl: categories[index].imageUrl,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 5),
      color: backgroundColor,
      height: Config.pageStyle.unitWidth * 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.only(
            left: Config.pageStyle.unitWidth * (index > 0 ? 2 : 0),
            bottom: Config.pageStyle.unitHeight * 3,
          ),
          child: ProductCard(
            cardWidth: Config.pageStyle.unitWidth * 120,
            cardHeight: Config.pageStyle.unitWidth * 175,
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
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 4, horizontal: Config.pageStyle.unitWidth * 10),
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: category,
            subCategory: [],
            brand: BrandEntity(),
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
        },
        title: 'view_all_grooming'.tr(),
        titleColor: Colors.white,
        titleSize: Config.pageStyle.unitFontSize * 18,
        icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: Config.pageStyle.unitFontSize * 24),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }
}
