import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'markaa_text_icon_button.dart';
import 'product_v_card.dart';

class ProductCustomVVCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isLine;
  final bool isMinor;
  final double borderRadius;
  final Function onAddToCartFailure;

  ProductCustomVVCard({
    required this.cardWidth,
    required this.cardHeight,
    required this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isLine = false,
    this.isMinor = true,
    this.borderRadius = 10,
    required this.onAddToCartFailure,
  });

  @override
  _ProductCustomVVCardState createState() => _ProductCustomVVCardState();
}

class _ProductCustomVVCardState extends State<ProductCustomVVCard> with TickerProviderStateMixin {
  int? index;
  bool isWishlist = false;
  bool isMaxed = false;

  late FlushBarService flushBarService;
  late ProgressService progressService;

  AnimationController? _addToCartController;
  Animation<double>? _addToCartScaleAnimation;
  AnimationController? _addToWishlistController;
  Animation<double>? _addToWishlistScaleAnimation;

  late MyCartChangeNotifier myCartChangeNotifier;
  late WishlistChangeNotifier wishlistChangeNotifier;

  bool get outOfStock => !(widget.product.stockQty! > 0);

  @override
  void initState() {
    isWishlist = false;
    super.initState();

    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();

    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);

    _initAnimation();
  }

  @override
  void didChangeDependencies() {
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
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _addToCartController!,
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
      parent: _addToWishlistController!,
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
      child: Consumer<MyCartChangeNotifier>(
        builder: (_, cartModel, __) {
          isMaxed = widget.product.typeId != 'configurable' &&
              cartModel.cartItemsCountMap.containsKey(widget.product.productId) &&
              widget.product.availableQty! <= (cartModel.cartItemsCountMap[widget.product.productId] as num);
          return Container(
            width: widget.cardWidth,
            height: widget.cardHeight,
            child: Stack(
              children: [
                _buildProductCard(),
                if (widget.product.discount! > 0) ...[
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
                if (widget.product.isDeal!) _buildDealValueLabel(),
                _buildToolbar(),
                if (outOfStock || isMaxed) _buildNotAvailablQty(outOfStock ? 'out_stock' : 'max_qty'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      color: Colors.white,
      shadowColor: greyLightColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              width: widget.cardHeight * 0.65,
              height: widget.cardHeight * 0.6,
              fit: BoxFit.fitHeight,
              errorWidget: (context, url, error) {
                return Center(child: Icon(Icons.image, size: 20.sp));
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.product.brandEntity?.optionId != null) {
                          ProductListArguments arguments = ProductListArguments(
                            category: null,
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
                        widget.product.brandEntity?.brandLabel ?? '',
                        style: mediumTextStyle.copyWith(
                          color: primaryColor,
                          fontSize: 14.sp,
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
                            fontSize: widget.isMinor ? 12.sp : 16.sp,
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
                          fontSize: widget.isMinor ? 12.sp : 16.sp,
                          fontWeight: FontWeight.w700,
                          height: 0.5,
                        ),
                      )
                    ],
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        children: [
                          Text(
                            widget.product.price + ' ' + 'currency'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: widget.isMinor ? 12.sp : 14.sp,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.product.discount! > 0) ...[
                            SizedBox(width: widget.isMinor ? 4.w : 10.w),
                            Text(
                              widget.product.beforePrice! + ' ' + 'currency'.tr(),
                              style: mediumTextStyle.copyWith(
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: dangerColor,
                                fontSize: widget.isMinor ? 12.sp : 14.sp,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.isLine) ...[Divider(color: primaryColor)],
                    if (widget.isShoppingCart) ...[
                      if (!outOfStock && !isMaxed) ...[
                        ScaleTransition(
                          scale: _addToCartScaleAnimation!,
                          child: Container(
                            width: widget.cardWidth - 16.w,
                            height: 35.h,
                            child: MarkaaTextIconButton(
                              leading: false,
                              icon: SvgPicture.asset(shoppingCartIcon, width: 18.w),
                              title: 'wishlist_add_cart_button_title'.tr(),
                              titleColor: Colors.white,
                              titleSize: 14.sp,
                              borderColor: Colors.transparent,
                              buttonColor: primarySwatchColor,
                              onPressed: () => _onAddProductToCart(),
                            ),
                          ),
                        )
                      ] else ...[
                        Container(
                          width: widget.cardWidth - 16.w,
                          height: 35.h,
                          child: MarkaaTextIconButton(
                            leading: false,
                            icon: SvgPicture.asset(shoppingCartIcon, width: 18.w),
                            title: 'wishlist_add_cart_button_title'.tr(),
                            titleColor: Colors.white,
                            titleSize: 14.sp,
                            borderColor: Colors.transparent,
                            buttonColor: greyColor,
                            onPressed: () => null,
                          ),
                        )
                      ],
                    ],
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscount() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      color: Colors.redAccent,
      alignment: Alignment.center,
      child: Text(
        '${widget.product.discount}% ${'off'.tr()}',
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: widget.isMinor ? 10.sp : 14.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDealValueLabel() {
    return Align(
      alignment: Preload.language == 'en' ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: widget.cardHeight * 0.6 - 22.h),
        child: ClipPath(
          clipper: DealClipPath(lang: Preload.language),
          child: Container(
            width: 66.w,
            height: 22.h,
            color: pinkColor,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'deal_label'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Consumer<WishlistChangeNotifier>(
      builder: (_, model, __) {
        isWishlist = model.wishlistItemsMap.containsKey(widget.product.productId);
        if (widget.isWishlist) {
          return Align(
            alignment: lang == 'en' ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => user != null ? _onWishlist() : Navigator.pushNamed(context, Routes.signIn),
                child: ScaleTransition(
                  scale: _addToWishlistScaleAnimation!,
                  child: Container(
                    width: isWishlist ? 22.w : 25.w,
                    height: isWishlist ? 22.w : 25.w,
                    child: isWishlist ? SvgPicture.asset(wishlistedIcon) : SvgPicture.asset(favoriteIcon),
                  ),
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

  Widget _buildNotAvailablQty(String label) {
    return Align(
      alignment: lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        color: outOfStock ? primarySwatchColor.withOpacity(0.4) : greyDarkColor.withOpacity(0.4),
        child: Text(
          label.tr(),
          style: mediumTextStyle.copyWith(fontSize: 14.sp, color: Colors.white70),
        ),
      ),
    );
  }

  void _onAddProductToCart() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      _addToCartController!.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToCartController!.stop(canceled: true);
        timer.cancel();
      });

      if (!outOfStock) {
        await myCartChangeNotifier.addProductToCart(widget.product, 1, lang, {},
            onProcess: _onAdding, onSuccess: _onAddSuccess, onFailure: _onAddFailure);
      } else {
        flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      }
    }
  }

  _onAdding() {
    progressService.addingProductProgress();
  }

  void _onAddSuccess() {
    progressService.hideProgress();
    ActionHandler.addedItemToCartSuccess(context, widget.product);
  }

  _onAddFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message, "no_qty.svg");
    widget.onAddToCartFailure();
  }

  void _onWishlist() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      _addToWishlistController!.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToWishlistController!.stop(canceled: true);
        timer.cancel();
      });
      if (isWishlist) {
        wishlistChangeNotifier.removeItemFromWishlist(user!.token, widget.product);
      } else {
        wishlistChangeNotifier.addItemToWishlist(user!.token, widget.product, 1, {});
      }
    }
  }
}
