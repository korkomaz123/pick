import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config.dart';

class ProductCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isLine;
  final bool isMinor;

  ProductCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isLine = false,
    this.isMinor = true,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  bool isWishlist;
  int index;
  FlushBarService flushBarService;
  // AnimationController _addToCartController;
  // Animation<double> _addToCartScaleAnimation;
  AnimationController _addToWishlistController;
  Animation<double> _addToWishlistScaleAnimation;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
    flushBarService = FlushBarService(context: context);
    _initAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initAnimation() {
    _addToWishlistController =
        AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 300), vsync: this);
    _addToWishlistScaleAnimation =
        Tween<double>(begin: 1.0, end: 3.0).animate(CurvedAnimation(parent: _addToWishlistController, curve: Curves.easeIn));
  }

  @override
  Widget build(BuildContext context) {
    if (widget?.product?.productId != null) {
      return InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.product,
          arguments: widget.product,
        ),
        child: Container(
          width: widget.cardWidth,
          height: widget.cardHeight,
          child: Stack(
            children: [
              _buildProductCard(),
              _buildToolbar(),
              _buildOutofStock(),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
      );
    }
  }

  Widget _buildProductCard() {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 8,
      ),
      child: Column(
        children: [
          Container(
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              width: widget.cardWidth,
              height: widget.cardWidth,
              fit: BoxFit.fitHeight,
              // progressIndicatorBuilder: (context, url, downloadProgress) =>
              //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isLine) ...[Divider(color: greyColor)],
                InkWell(
                  onTap: () {
                    if (widget?.product?.brandEntity?.optionId != null) {
                      ProductListArguments arguments = ProductListArguments(
                        category: CategoryEntity(),
                        subCategory: [],
                        brand: widget.product.brandEntity,
                        selectedSubCategoryIndex: 0,
                        isFromBrand: true,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.productList,
                        arguments: arguments,
                      );
                    }
                  },
                  child: Text(
                    widget?.product?.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: Config.pageStyle.unitFontSize * 10,
                    ),
                  ),
                ),
                Text(
                  widget.product.price != null ? (widget.product.price + ' ' + 'currency'.tr()) : '',
                  style: mediumTextStyle.copyWith(
                    fontSize: Config.pageStyle.unitFontSize * (widget.isMinor ? 10 : 10),
                    color: greyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (widget.product.discount > 0) ...[
                  SizedBox(width: Config.pageStyle.unitWidth * (widget.isMinor ? 4 : 4)),
                  Text(
                    widget.product.beforePrice + ' ' + 'currency'.tr(),
                    style: mediumTextStyle.copyWith(
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: dangerColor,
                      fontSize: Config.pageStyle.unitFontSize * (widget.isMinor ? 10 : 10),
                      color: greyColor,
                    ),
                  ),
                ],
                SizedBox(height: Config.pageStyle.unitHeight * 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Consumer<WishlistChangeNotifier>(builder: (_, model, __) {
      isWishlist = model.wishlistItemsMap.containsKey(widget.product.productId);
      if (widget.isWishlist) {
        return Align(
          alignment: lang == 'en' ? Alignment.topRight : Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => user != null ? _onWishlist(model) : Navigator.pushNamed(context, Routes.signIn),
              child: ScaleTransition(
                scale: _addToWishlistScaleAnimation,
                child: Container(
                  width: Config.pageStyle.unitWidth * (isWishlist ? 18 : 22),
                  height: Config.pageStyle.unitWidth * (isWishlist ? 18 : 22),
                  child: isWishlist ? SvgPicture.asset(wishlistedIcon) : SvgPicture.asset(favoriteIcon),
                ),
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildOutofStock() {
    if (widget.product.typeId == 'simple' && (widget.product.stockQty == null || widget.product.stockQty == 0)) {
      return Align(
        alignment: lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Config.pageStyle.unitWidth * 10,
            vertical: Config.pageStyle.unitHeight * 3,
          ),
          color: primarySwatchColor.withOpacity(0.4),
          child: Text(
            'out_stock'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 10,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  void _onWishlist(WishlistChangeNotifier wishlistChangeNotifier) async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      _addToWishlistController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToWishlistController.stop(canceled: true);
        timer.cancel();
      });
      if (isWishlist) {
        wishlistChangeNotifier.removeItemFromWishlist(user.token, widget.product);
      } else {
        wishlistChangeNotifier.addItemToWishlist(user.token, widget.product, 1, {});
      }
    }
  }
}
