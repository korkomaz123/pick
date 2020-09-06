import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:share/share.dart';

class ProductVCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductEntity product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final PageStyle pageStyle;

  ProductVCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
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
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.product,
                      arguments: product,
                    ),
                    child: Image.asset(
                      'lib/public/images/shutterstock_151558448-1.png',
                      width: cardWidth,
                      height: cardHeight * 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
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
                            fontSize: pageStyle.unitFontSize * 12,
                            height: pageStyle.unitHeight * 1.2,
                          ),
                        ),
                      ),
                      // SizedBox(height: pageStyle.unitHeight * 10),
                      Row(
                        children: [
                          Text(
                            product.price.toString() + ' ' + 'currency'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: pageStyle.unitFontSize * 12,
                              color: greyColor,
                            ),
                          ),
                          SizedBox(width: pageStyle.unitWidth * 10),
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
                          SizedBox(width: pageStyle.unitWidth * 10),
                          isShoppingCart
                              ? InkWell(
                                  onTap: () =>
                                      _onAddProductToCart(context, product),
                                  child: Container(
                                    width: pageStyle.unitWidth * 18,
                                    height: pageStyle.unitHeight * 17,
                                    child: SvgPicture.asset(shoppingCartIcon,
                                        color: primaryColor),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              isShare
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => _onShareProduct(),
                          child: Icon(
                            Icons.share,
                            color: greyColor,
                            size: pageStyle.unitFontSize * 20,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
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
                            child: SvgPicture.asset(wishlistIcon,
                                color: greyColor),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  void _onAddProductToCart(BuildContext context, ProductEntity product) {
    Flushbar(
      messageText: Container(
        width: pageStyle.unitWidth * 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 15,
                  ),
                ),
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cart Total',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
                Text(
                  'KD 460',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: pageStyle.unitWidth * 20,
        height: pageStyle.unitHeight * 20,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[100],
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: primaryColor,
    )..show(context);
  }

  void _onShareProduct() {
    Share.share('Share my product');
  }
}
