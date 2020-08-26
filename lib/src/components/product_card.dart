import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductEntity product;
  final bool isShoppingCart;
  final PageStyle pageStyle;

  ProductCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.pageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 8),
      child: Column(
        children: [
          Image.asset(
            'lib/public/images/shutterstock_151558448-1.png',
            width: cardWidth * 0.5,
            height: cardHeight * 0.64,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jazzia Group',
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: cardWidth * 0.2,
                  ),
                  child: Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: pageStyle.unitFontSize * 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      product.price.toString() + ' KD',
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 20),
                    Text(
                      product.discount.toString() + ' KD',
                      style: mediumTextStyle.copyWith(
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: dangerColor,
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
