import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
// import 'package:share/share.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final PageStyle pageStyle;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.pageStyle,
  });

  @override
  _ProductHCardState createState() => _ProductHCardState();
}

class _ProductHCardState extends State<ProductHCard> {
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: widget.product,
                  ),
                  child: Image.network(
                    widget.product.imageUrl,
                    width: widget.cardWidth * 0.4,
                    height: widget.cardHeight * 0.7,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: widget.cardHeight * 0.2),
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
                          fontSize: widget.pageStyle.unitFontSize * 14,
                        ),
                      ),
                      SizedBox(height: widget.pageStyle.unitHeight * 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.price + ' ' + 'currency'.tr(),
                              style: mediumTextStyle.copyWith(
                                fontSize: widget.pageStyle.unitFontSize * 12,
                                color: greyColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.product.price + ' ' + 'currency'.tr(),
                              style: mediumTextStyle.copyWith(
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: dangerColor,
                                fontSize: widget.pageStyle.unitFontSize * 12,
                                color: greyColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          widget.isShoppingCart
                              ? InkWell(
                                  onTap: () => _onAddProductToCart(
                                    context,
                                    widget.product,
                                  ),
                                  child: Container(
                                    width: widget.pageStyle.unitWidth * 18,
                                    height: widget.pageStyle.unitHeight * 17,
                                    child: SvgPicture.asset(
                                      shoppingCartIcon,
                                      color: primaryColor,
                                    ),
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

  void _onAddProductToCart(BuildContext context, ProductModel product) {
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
}
