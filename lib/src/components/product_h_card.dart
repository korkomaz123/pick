import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_v_card.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isDesc;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isMinor;
  final Function? onTap;
  final Function? onAddToCartFailure;

  ProductHCard({
    required this.cardWidth,
    required this.cardHeight,
    required this.product,
    this.isDesc = false,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isMinor = true,
    this.onTap,
    this.onAddToCartFailure,
  });

  @override
  _ProductHCardState createState() => _ProductHCardState();
}

class _ProductHCardState extends State<ProductHCard>
    with TickerProviderStateMixin {
  FlushBarService? flushBarService;
  ProgressService? progressService;

  AnimationController? _addToCartController;
  Animation<double>? _addToCartScaleAnimation;
  AnimationController? _addToWishlistController;
  Animation<double>? _addToWishlistScaleAnimation;

  MyCartChangeNotifier? myCartChangeNotifier;
  WishlistChangeNotifier? wishlistChangeNotifier;

  int? index;
  bool? isWishlist;

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
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.product,
          arguments: widget.product,
        );
        widget.onTap!();
      },
      child: Container(
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
            if (widget.product.isDeal!) ...[_buildDealValueLabel()],
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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: lang == 'en' ? 5.w : 0,
              left: lang == 'ar' ? 5.w : 0,
            ),
            child: CachedNetworkImage(
              key: ValueKey(widget.product.imageUrl),
              cacheKey: widget.product.imageUrl,
              imageUrl: widget.product.imageUrl,
              width: widget.cardWidth * 0.34,
              height: widget.cardHeight,
              fit: BoxFit.fitHeight,
              errorWidget: (context, url, error) {
                return Center(child: Icon(Icons.image, size: 20.sp));
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    if (widget.product.brandEntity != null) {
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
                Padding(
                  padding: EdgeInsets.only(
                    right: lang == 'en' ? 20.w : 0,
                    left: lang == 'ar' ? 20.w : 0,
                  ),
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
                ),
                if (widget.isDesc) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      right: lang == 'en' ? 20.w : 0,
                      left: lang == 'ar' ? 20.w : 0,
                    ),
                    child: Text(
                      widget.product.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: widget.isMinor ? 10.sp : 14.sp,
                      ),
                    ),
                  )
                ],
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            (widget.product.price + ' ' + 'currency'.tr()),
                            style: mediumTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.product.discount! > 0) ...[
                            SizedBox(
                              width: widget.isMinor ? 4.w : 10.w,
                            ),
                            Text(
                              widget.product.beforePrice! +
                                  ' ' +
                                  'currency'.tr(),
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
                    if (widget.isShoppingCart) ...[
                      if (!outOfStock) ...[
                        Consumer<MarkaaAppChangeNotifier>(
                          builder: (_, model, __) {
                            return InkWell(
                              onTap: () {
                                if (model.activeAddCart) {
                                  model.changeAddCartStatus(false);
                                  _onAddProductToCart();
                                  model.changeAddCartStatus(true);
                                }
                              },
                              child: ScaleTransition(
                                scale: _addToCartScaleAnimation!,
                                child: Container(
                                  width: 32.h,
                                  height: 32.h,
                                  child: SvgPicture.asset(addCartIcon),
                                ),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        Container(
                          width: 32.h,
                          height: 32.h,
                          child: SvgPicture.asset(greyAddCartIcon),
                        )
                      ]
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
      alignment:
          Preload.language == 'en' ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: widget.cardHeight * 0.45),
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
                scale: _addToWishlistScaleAnimation!,
                child: Container(
                  width: isWishlist! ? 22.sp : 25.sp,
                  height: isWishlist! ? 22.sp : 25.sp,
                  child: isWishlist!
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
    if (outOfStock) {
      return Align(
        alignment: lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 5.h,
          ),
          color: primarySwatchColor.withOpacity(0.4),
          child: Text(
            'out_stock'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 14.sp,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Container();
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
        await myCartChangeNotifier!.addProductToCart(
            widget.product, 1, lang, {},
            onProcess: _onAdding,
            onSuccess: _onAddSuccess,
            onFailure: _onAddFailure);
      } else {
        flushBarService!
            .showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      }
    }
  }

  _onAdding() {
    progressService!.addingProductProgress();
  }

  _onAddSuccess() {
    progressService!.hideProgress();
    ActionHandler.addedItemToCartSuccess(context, widget.product);
  }

  _onAddFailure(String message) {
    progressService!.hideProgress();
    flushBarService!.showErrorDialog(message, "no_qty.svg");
    widget.onAddToCartFailure!();
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
      if (isWishlist!) {
        wishlistChangeNotifier!
            .removeItemFromWishlist(user!.token, widget.product);
      } else {
        wishlistChangeNotifier!
            .addItemToWishlist(user!.token, widget.product, 1, {});
      }
    }
  }
}
