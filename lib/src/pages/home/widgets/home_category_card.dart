import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/config.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeCategoryCard extends StatelessWidget {
  final CategoryEntity category;

  HomeCategoryCard({this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
      child: Container(
        width: Config.pageStyle.deviceWidth,
        height: Config.pageStyle.unitHeight * 249,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(category.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Config.pageStyle.unitWidth * 18,
          vertical: Config.pageStyle.unitHeight * 23,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Config.pageStyle.deviceWidth / 2,
              child: Text(
                category.name,
                style: mediumTextStyle.copyWith(
                  color: darkColor,
                  fontSize: Config.pageStyle.unitFontSize * 23,
                ),
              ),
            ),
            Container(
              width: Config.pageStyle.deviceWidth / 2,
              padding: EdgeInsets.only(top: Config.pageStyle.unitHeight * 10),
              child: Text(
                category.description ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: Config.pageStyle.unitFontSize * 10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: Config.pageStyle.unitHeight * 4),
              child: MarkaaTextButton(
                title: 'view_all'.tr(),
                titleSize: Config.pageStyle.unitFontSize * 18,
                titleColor: greyDarkColor,
                buttonColor: Colors.transparent,
                borderColor: greyDarkColor,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
