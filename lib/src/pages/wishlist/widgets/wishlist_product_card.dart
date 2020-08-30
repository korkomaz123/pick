import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class WishlistProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductEntity product;
  final Function onRemoveWishlist;

  WishlistProductCard({this.pageStyle, this.product, this.onRemoveWishlist});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onRemoveWishlist,
            child: Icon(
              Icons.remove_circle_outline,
              size: pageStyle.unitFontSize * 22,
              color: greyDarkColor,
            ),
          ),
          Image.asset(
            'lib/public/images/shutterstock_151558448-1.png',
            width: pageStyle.unitWidth * 134,
            height: pageStyle.unitHeight * 150,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: boldTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 17,
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
                SizedBox(height: pageStyle.unitHeight * 10),
                TextButton(
                  title: 'ADD TO CART',
                  titleSize: pageStyle.unitFontSize * 15,
                  titleColor: Colors.white,
                  buttonColor: primaryColor,
                  borderColor: Colors.transparent,
                  onPressed: () => null,
                  radius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
