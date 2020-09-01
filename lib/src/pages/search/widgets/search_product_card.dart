import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SearchProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductEntity product;

  SearchProductCard({this.pageStyle, this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'lib/public/images/shutterstock_153837233@3x.png',
            width: pageStyle.unitWidth * 90,
            height: pageStyle.unitHeight * 90,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.store.name,
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 10,
                  ),
                ),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: pageStyle.unitWidth * 10),
          Text(
            product.price.toString() + ' ' + 'currency'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ],
      ),
    );
  }
}
