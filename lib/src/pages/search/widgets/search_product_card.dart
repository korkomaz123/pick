import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SearchProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductModel product;

  SearchProductCard({this.pageStyle, this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            product.imageUrl,
            width: pageStyle.unitWidth * 50,
            height: pageStyle.unitHeight * 50,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: Text(
              product.name,
              style: mediumTextStyle.copyWith(
                color: Colors.black,
                fontSize: pageStyle.unitFontSize * 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: pageStyle.unitWidth * 10),
          Text(
            product.price + ' ' + 'currency'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 12,
            ),
          ),
        ],
      ),
    );
  }
}
