import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductHCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductEntity product;
  final bool isShoppingCart;
  final bool isWishlist;
  final PageStyle pageStyle;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.pageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: product,
                  ),
                  child: Image.asset(
                    'lib/public/images/shutterstock_151558448-1.png',
                    width: cardWidth * 0.4,
                    height: cardHeight,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Jazzia Group',
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
                      Row(
                        children: [
                          Text(
                            product.price.toString() + ' ' + 'currency'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: pageStyle.unitFontSize * 12,
                              color: greyColor,
                            ),
                          ),
                          SizedBox(width: pageStyle.unitWidth * 20),
                          Text(
                            product.discount.toString() + ' ' + 'currency'.tr(),
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
          ),
          isWishlist
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => null,
                      child: Container(
                        width: pageStyle.unitWidth * 18,
                        height: pageStyle.unitHeight * 17,
                        child: SvgPicture.asset(wishlistIcon, color: greyColor),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          isShoppingCart
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => null,
                      child: Container(
                        width: pageStyle.unitWidth * 18,
                        height: pageStyle.unitHeight * 17,
                        child: SvgPicture.asset(shoppingCartIcon,
                            color: primaryColor),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
