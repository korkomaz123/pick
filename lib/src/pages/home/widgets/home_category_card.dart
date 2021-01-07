import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeCategoryCard extends StatelessWidget {
  final PageStyle pageStyle;
  final CategoryEntity category;

  HomeCategoryCard({this.pageStyle, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 249,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(category.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 18,
        vertical: pageStyle.unitHeight * 23,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: mediumTextStyle.copyWith(
              color: darkColor,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          Container(
            width: pageStyle.deviceWidth / 2,
            padding: EdgeInsets.only(top: pageStyle.unitHeight * 10),
            child: Text(
              category.description ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: mediumTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: pageStyle.unitFontSize * 10,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: pageStyle.unitHeight * 4),
            child: CigaTextButton(
              title: 'view_all'.tr(),
              titleSize: pageStyle.unitFontSize * 18,
              titleColor: Colors.white,
              buttonColor: Colors.transparent,
              borderColor: Colors.white,
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
    );
  }
}
