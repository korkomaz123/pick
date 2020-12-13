import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductMoreAbout extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductEntity productEntity;

  ProductMoreAbout({this.pageStyle, this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 30,
      ),
      margin: EdgeInsets.only(top: pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product_more_about'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 19,
            ),
          ),
          SizedBox(height: pageStyle.unitFontSize * 4),
          Text(
            productEntity.description,
            style: mediumTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 12,
            ),
          ),
        ],
      ),
    );
  }
}
