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

class ProductVCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isLine;
  final bool isMinor;
  final PageStyle pageStyle;

  ProductVCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isLine = false,
    this.isMinor = true,
    this.pageStyle,
  });

  @override
  _ProductVCardState createState() => _ProductVCardState();
}

class _ProductVCardState extends State<ProductVCard>
    with TickerProviderStateMixin {
  bool isWishlist;
  int index;
  FlushBarService flushBarService;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
  AnimationController _addToWishlistController;
  Animation<double> _addToWishlistScaleAnimation;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  Image cachedImage;

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
    if (widget?.product?.productId != null) {
      cachedImage = Image.network(
        widget.product.imageUrl,
        width: widget.cardHeight * 0.65,
        height: widget.cardHeight * 0.6,
        fit: BoxFit.fitHeight,
      );
      precacheImage(cachedImage.image, context);
    }
    super.didChangeDependencies();
  }

  void _initAnimation() {
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
        horizontal: widget.pageStyle.unitWidth * 8,
      ),
      child: Column(
        children: [
          Container(
            child: cachedImage ??
                SizedBox(
                  width: widget.cardHeight * 0.65,
                  height: widget.cardHeight * 0.6,
                ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (widget.isLine || widget.isMinor) ...[
                  Expanded(
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
                  )
                ] else ...[
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: widget.pageStyle.unitFontSize *
                          (widget.isMinor ? 12 : 16),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
                if (widget.isLine) ...[Divider(color: greyColor)],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    if (widget.isShoppingCart &&
                        (widget.product.typeId != 'simple' ||
                            widget.product.stockQty != null &&
                                widget.product.stockQty > 0)) ...[
                      InkWell(
                        onTap: () => _onAddProductToCart(context),
                        child: ScaleTransition(
                          scale: _addToCartScaleAnimation,
                          child: Container(
                            width: widget.pageStyle.unitWidth *
                                (widget.isMinor ? 26 : 32),
                            height: widget.pageStyle.unitWidth *
                                (widget.isMinor ? 26 : 32),
                            child: SvgPicture.asset(addCartIcon),
                          ),
                        ),
                      )
                    ] else ...[
                      SizedBox.shrink()
                    ],
                  ],
                ),
                SizedBox(height: widget.pageStyle.unitHeight * 5),
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
              onTap: () => user != null
                  ? _onWishlist()
                  : Navigator.pushNamed(context, Routes.signIn),
              child: ScaleTransition(
                scale: _addToWishlistScaleAnimation,
                child: Container(
                  width: widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                  height: widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                  child: isWishlist
                      ? SvgPicture.asset(wishlistedIcon)
                      : SvgPicture.asset(favoriteIcon),
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
    return SizedBox.shrink();
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
      _addToWishlistController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToWishlistController.stop(canceled: true);
        timer.cancel();
      });
      if (isWishlist) {
        wishlistChangeNotifier.removeItemFromWishlist(
            user.token, widget.product);
      } else {
        wishlistChangeNotifier
            .addItemToWishlist(user.token, widget.product, 1, {});
      }
    }
  }
}
