import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isMinor;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isMinor = true,
  });

  @override
  _ProductHCardState createState() => _ProductHCardState();
}

class _ProductHCardState extends State<ProductHCard> with TickerProviderStateMixin {
  bool isWishlist;
  int index;
  FlushBarService flushBarService;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
  AnimationController _addToWishlistController;
  Animation<double> _addToWishlistScaleAnimation;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    flushBarService = FlushBarService(context: context);
    _initAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initAnimation() {
    /// add to cart button animation
    _addToCartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _addToCartScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _addToCartController,
      curve: Curves.easeIn,
    ));

    /// add to wishlist button animation
    _addToWishlistController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _addToWishlistScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _addToWishlistController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
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
            if (widget.product.discount > 0) ...[
              if (lang == 'en') ...[
                Positioned(
                  top: 0,
                  left: 0,
                  child: _buildDiscount(),
                ),
              ] else ...[
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildDiscount(),
                ),
              ],
            ],
            _buildToolbar(),
            _buildOutofStock(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: lang == 'en' ? Config.pageStyle.unitWidth * 5 : 0,
              left: lang == 'ar' ? Config.pageStyle.unitWidth * 5 : 0,
            ),
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              width: widget.cardHeight * 0.65,
              height: widget.cardHeight * 0.8,
              fit: BoxFit.fitHeight,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.cardHeight * 0.1),
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
                      fontSize: Config.pageStyle.unitFontSize * 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: lang == 'en' ? Config.pageStyle.unitWidth * 20 : 0,
                    left: lang == 'ar' ? Config.pageStyle.unitWidth * 20 : 0,
                  ),
                  child: Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: Config.pageStyle.unitFontSize * (widget.isMinor ? 12 : 16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: Config.pageStyle.unitHeight * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.product.price != null ? (widget.product.price + ' ' + 'currency'.tr()) : '',
                            style: mediumTextStyle.copyWith(
                              fontSize: Config.pageStyle.unitFontSize * 14,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.product.discount > 0) ...[
                            SizedBox(
                              width: Config.pageStyle.unitWidth * (widget.isMinor ? 4 : 10),
                            ),
                            Text(
                              widget.product.beforePrice + ' ' + 'currency'.tr(),
                              style: mediumTextStyle.copyWith(
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: dangerColor,
                                fontSize: Config.pageStyle.unitFontSize * (widget.isMinor ? 12 : 14),
                                color: greyColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.isShoppingCart &&
                        (widget.product.typeId != 'simple' || widget.product.stockQty != null && widget.product.stockQty > 0)) ...[
                      InkWell(
                        onTap: () => _onAddProductToCart(context),
                        child: ScaleTransition(
                          scale: _addToCartScaleAnimation,
                          child: Container(
                            width: Config.pageStyle.unitHeight * 32,
                            height: Config.pageStyle.unitHeight * 32,
                            child: SvgPicture.asset(addCartIcon),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 4,
        vertical: Config.pageStyle.unitHeight * 2,
      ),
      color: Colors.redAccent,
      alignment: Alignment.center,
      child: Text(
        '${widget.product.discount}% ${'off'.tr()}',
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: Config.pageStyle.unitFontSize * (widget.isMinor ? 10 : 14),
          color: Colors.white,
        ),
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
              onTap: () => user != null ? _onWishlist() : Navigator.pushNamed(context, Routes.signIn),
              child: ScaleTransition(
                scale: _addToWishlistScaleAnimation,
                child: Container(
                  width: Config.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                  height: Config.pageStyle.unitWidth * (isWishlist ? 22 : 25),
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
            horizontal: Config.pageStyle.unitWidth * 15,
            vertical: Config.pageStyle.unitHeight * 5,
          ),
          color: primarySwatchColor.withOpacity(0.4),
          child: Text(
            'out_stock'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 14,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  void _onAddProductToCart(BuildContext context) async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      _addToCartController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToCartController.stop(canceled: true);
        timer.cancel();
      });
      if (widget.product.stockQty != null && widget.product.stockQty > 0) {
        await myCartChangeNotifier.addProductToCart(context, Config.pageStyle, widget.product, 1, lang, {});
      } else {
        flushBarService.showErrorMessage(
          Config.pageStyle,
          'out_of_stock_error'.tr(),
        );
      }
    }
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCartToken);
    Adjust.trackEvent(adjustEvent);
  }

  void _onWishlist() async {
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
