import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/strings.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'home_products_carousel.dart';

class HomeCategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final PageStyle pageStyle;

  HomeCategoryCard({this.category, this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 420,
      padding: EdgeInsets.all(pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Column(
        children: [
          _buildHeadline(),
          HomeProductsCarousel(
            pageStyle: pageStyle,
            products: category.products,
          ),
          Divider(
            height: pageStyle.unitHeight * 4,
            thickness: pageStyle.unitHeight * 1.5,
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
            category.name,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 23,
              color: greyDarkColor,
            ),
          ),
          InkWell(
            onTap: () => null,
            child: Container(
              width: pageStyle.unitWidth * 18,
              height: pageStyle.unitHeight * 17,
              child: SvgPicture.asset(wishlistIcon, color: greyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 4),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, Routes.productList),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              seeAllTitle,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 15,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: pageStyle.unitFontSize * 15,
            ),
          ],
        ),
      ),
    );
  }
}
