import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'home_products_carousel.dart';

class HomeRecent extends StatelessWidget {
  final PageStyle pageStyle;

  HomeRecent({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 420,
      padding: EdgeInsets.all(pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_recently_view'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 23,
              color: greyDarkColor,
            ),
          ),
          HomeProductsCarousel(
            pageStyle: pageStyle,
            products: [],
            crossAxisCount: 2,
          ),
          Divider(
            height: pageStyle.unitHeight * 4,
            thickness: pageStyle.unitHeight * 1.5,
            color: greyColor.withOpacity(0.4),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 4),
      child: InkWell(
        onTap: () => null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_all'.tr(),
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
