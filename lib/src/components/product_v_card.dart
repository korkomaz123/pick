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

class ProductVCard extends StatefulWidget {
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
  _ProductVCardState createState() => _ProductVCardState();
}

class _ProductVCardState extends State<ProductVCard> {
  bool isWishlist;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      child: Stack(
        children: [
          Container(
            width: widget.cardWidth,
            height: widget.cardHeight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: widget.pageStyle.unitWidth * 8,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.product,
                      arguments: widget.product,
                    ),
                    child: Image.asset(
                      'lib/public/images/shutterstock_151558448-1.png',
                      fit: BoxFit.cover,
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
                          fontSize: widget.pageStyle.unitFontSize * 10,
                        ),
                      ),
                      Text(
                        widget.product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: mediumTextStyle.copyWith(
                          color: greyDarkColor,
                          fontSize: widget.pageStyle.unitFontSize * 12,
                          height: widget.pageStyle.unitHeight * 1.2,
                        ),
                      ),
                      // SizedBox(height: pageStyle.unitHeight * 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.price.toString() +
                                ' ' +
                                'currency'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: widget.pageStyle.unitFontSize * 12,
                              color: greyColor,
                            ),
                          ),
                          SizedBox(width: widget.pageStyle.unitWidth * 10),
                          Text(
                            widget.product.discount.toString() +
                                ' ' +
                                'currency'.tr(),
                            style: mediumTextStyle.copyWith(
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: dangerColor,
                              fontSize: widget.pageStyle.unitFontSize * 12,
                              color: greyColor,
                            ),
                          ),
                          Spacer(),
                          widget.isShoppingCart
                              ? InkWell(
                                  onTap: () => _onAddProductToCart(
                                      context, widget.product),
                                  child: Container(
                                    width: widget.pageStyle.unitWidth * 18,
                                    height: widget.pageStyle.unitHeight * 17,
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
              widget.isShare
                  ? Align(
                      alignment:
                          EasyLocalization.of(context).locale.languageCode ==
                                  'en'
                              ? Alignment.topRight
                              : Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => _onShareProduct(),
                          child: Icon(
                            Icons.share,
                            color: greyColor,
                            size: widget.pageStyle.unitFontSize * 20,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              widget.isWishlist
                  ? Align(
                      alignment:
                          EasyLocalization.of(context).locale.languageCode ==
                                  'en'
                              ? Alignment.topRight
                              : Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => setState(() {
                            isWishlist = !isWishlist;
                          }),
                          child: Container(
                            width: widget.pageStyle.unitWidth * 18,
                            height: widget.pageStyle.unitHeight * 17,
                            child: isWishlist
                                ? SvgPicture.asset(wishlistedIcon)
                                : SvgPicture.asset(
                                    wishlistIcon,
                                    color: greyColor,
                                  ),
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
        width: widget.pageStyle.unitWidth * 300,
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
                    fontSize: widget.pageStyle.unitFontSize * 15,
                  ),
                ),
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: widget.pageStyle.unitFontSize * 12,
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
                    fontSize: widget.pageStyle.unitFontSize * 13,
                  ),
                ),
                Text(
                  'KD 460',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: widget.pageStyle.unitFontSize * 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: widget.pageStyle.unitWidth * 20,
        height: widget.pageStyle.unitHeight * 20,
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
