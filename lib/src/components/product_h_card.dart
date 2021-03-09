import 'dart:async';

import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isMinor;
  final PageStyle pageStyle;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isMinor = true,
    this.pageStyle,
  });

  @override
  _ProductHCardState createState() => _ProductHCardState();
}

class _ProductHCardState extends State<ProductHCard>
    with TickerProviderStateMixin {
  bool isWishlist;
  int index;
  FlushBarService flushBarService;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
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
        horizontal: widget.pageStyle.unitWidth * 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: lang == 'en' ? widget.pageStyle.unitWidth * 5 : 0,
              left: lang == 'ar' ? widget.pageStyle.unitWidth * 5 : 0,
            ),
            child: Image.network(
              widget.product.imageUrl,
              width: widget.cardHeight * 0.65,
              height: widget.cardHeight * 0.8,
              fit: BoxFit.fitHeight,
              loadingBuilder: (_, child, chunkEvent) {
                return chunkEvent != null
                    ? Image.asset(
                        'lib/public/images/loading/image_loading.jpg',
                        width: widget.cardHeight * 0.65,
                        height: widget.cardHeight * 0.8,
                      )
                    : child;
              },
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
                      fontSize: widget.pageStyle.unitFontSize * 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: lang == 'en' ? widget.pageStyle.unitWidth * 20 : 0,
                    left: lang == 'ar' ? widget.pageStyle.unitWidth * 20 : 0,
                  ),
                  child: Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: widget.pageStyle.unitFontSize *
                          (widget.isMinor ? 12 : 16),
                      fontWeight: FontWeight.w700,
                    ),
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
                          fontSize: widget.pageStyle.unitFontSize * 14,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    widget.isShoppingCart &&
                            (widget.product.typeId != 'simple' ||
                                widget.product.stockQty != null &&
                                    widget.product.stockQty > 0)
                        ? InkWell(
                            onTap: () => _onAddProductToCart(context),
                            child: ScaleTransition(
                              scale: _addToCartScaleAnimation,
                              child: Container(
                                width: widget.pageStyle.unitHeight * 32,
                                height: widget.pageStyle.unitHeight * 32,
                                child: SvgPicture.asset(addCartIcon),
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
    );
  }

  Widget _buildToolbar() {
    return Consumer<WishlistChangeNotifier>(
      builder: (_, model, __) {
        if (widget.isWishlist) {
          isWishlist =
              model.wishlistItemsMap.containsKey(widget.product.productId);
          return Align(
            alignment: lang == 'en' ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => user != null
                    ? _onWishlist()
                    : Navigator.pushNamed(context, Routes.signIn),
                child: Container(
                  width: widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                  height: widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                  child: isWishlist
                      ? SvgPicture.asset(wishlistedIcon)
                      : SvgPicture.asset(favoriteIcon),
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildOutofStock() {
    if (widget.product.typeId == 'simple' &&
        (widget.product.stockQty == null || widget.product.stockQty == 0)) {
      return Align(
        alignment: lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.pageStyle.unitWidth * 15,
            vertical: widget.pageStyle.unitHeight * 5,
          ),
          color: primarySwatchColor.withOpacity(0.4),
          child: Text(
            'out_stock'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: widget.pageStyle.unitFontSize * 14,
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
        await myCartChangeNotifier.addProductToCart(
            context, widget.pageStyle, widget.product, 1, lang, {});
      } else {
        flushBarService.showErrorMessage(
          widget.pageStyle,
          'out_of_stock_error'.tr(),
        );
      }
    }
  }

  void _onWishlist() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      if (isWishlist) {
        await wishlistChangeNotifier.removeItemFromWishlist(
            user.token, widget.product.productId);
      } else {
        await wishlistChangeNotifier
            .addItemToWishlist(user.token, widget.product, 1, {});
      }
    }
  }
}
