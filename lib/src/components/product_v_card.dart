import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/custom/sliding_sheet.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';
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
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/preload.dart';

class ProductVCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isLine;
  final bool isMinor;
  final Function onTap;
  final Function onAddToCartFailure;

  ProductVCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isLine = false,
    this.isMinor = true,
    this.onTap,
    this.onAddToCartFailure,
  });

  @override
  _ProductVCardState createState() => _ProductVCardState();
}

class _ProductVCardState extends State<ProductVCard>
    with TickerProviderStateMixin {
  bool _isWishlist;

  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
  AnimationController _addToWishlistController;
  Animation<double> _addToWishlistScaleAnimation;

  MyCartChangeNotifier _myCartChangeNotifier;

  FlushBarService _flushBarService;
  ProgressService _progressService;

  bool get outOfStock =>
      !(widget.product.stockQty != null && widget.product.stockQty > 0);

  @override
  void initState() {
    _isWishlist = false;
    super.initState();

    _myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _flushBarService = FlushBarService(context: context);
    _progressService = ProgressService(context: context);
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
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.product,
            arguments: widget.product,
          );
          if (widget.onTap != null) widget.onTap();
        },
        child: Container(
          width: widget.cardWidth,
          height: widget.cardHeight,
          child: Stack(
            children: [
              _buildProductCard(),
              if (widget.product.discount > 0) ...[
                if (Preload.language == 'en') ...[
                  Positioned(top: 0, left: 0, child: _buildDiscount()),
                ] else ...[
                  Positioned(top: 0, right: 0, child: _buildDiscount()),
                ],
              ],
              if (widget.product.isDeal) ...[_buildDealValueLabel()],
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
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.product.imageUrl,
            width: widget.cardWidth,
            height: widget.cardHeight * 0.63,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Center(child: Icon(Icons.image, size: 20.sp));
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Text(
                  widget.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: widget.isMinor ? 12.sp : 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                if (widget.isLine) ...[
                  Divider(color: greyColor, thickness: 0.5.h, height: 10.h)
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.product.price != null
                                ? (widget.product.price + ' ' + 'currency'.tr())
                                : '',
                            style: mediumTextStyle.copyWith(
                              fontSize: widget.isMinor ? 12.sp : 14.sp,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (widget.product.discount > 0) ...[
                            SizedBox(width: widget.isMinor ? 4.w : 10.w),
                            Text(
                              widget.product.beforePrice +
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
                      Consumer<MarkaaAppChangeNotifier>(
                        builder: (_, model, __) {
                          if (!outOfStock) {
                            return InkWell(
                              onTap: () {
                                if (model.activeAddCart) {
                                  model.changeAddCartStatus(false);
                                  _onAddProductToCart();
                                  model.changeAddCartStatus(true);
                                }
                              },
                              child: ScaleTransition(
                                scale: _addToCartScaleAnimation,
                                child: Container(
                                  width: widget.isMinor ? 26.w : 32.w,
                                  height: widget.isMinor ? 26.w : 32.w,
                                  child: SvgPicture.asset(addCartIcon),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: widget.isMinor ? 26.w : 32.w,
                              height: widget.isMinor ? 26.w : 32.w,
                              child: SvgPicture.asset(greyAddCartIcon),
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 5.h),
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
        padding: EdgeInsets.only(top: widget.cardHeight * 0.63 - 22.h),
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
        _isWishlist =
            model.wishlistItemsMap.containsKey(widget.product.productId);
        if (widget.isWishlist) {
          return Align(
            alignment: Preload.language == 'en'
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (user != null) {
                    _onWishlist();
                  } else {
                    Navigator.pushNamed(
                      Preload.navigatorKey.currentContext,
                      Routes.signIn,
                    );
                  }
                },
                child: ScaleTransition(
                  scale: _addToWishlistScaleAnimation,
                  child: Container(
                    width: _isWishlist ? 22.w : 25.w,
                    height: _isWishlist ? 22.w : 25.w,
                    child: _isWishlist
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
      },
    );
  }

  Widget _buildOutofStock() {
    if (outOfStock) {
      return Align(
        alignment: Preload.language == 'en'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
    return SizedBox.shrink();
  }

  void _onAddProductToCart() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(
        Preload.navigatorKey.currentContext,
        Routes.product,
        arguments: widget.product,
      );
    } else {
      _addToCartController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToCartController.stop(canceled: true);
        timer.cancel();
      });

      if (widget.product.stockQty != null && widget.product.stockQty > 0) {
        await _myCartChangeNotifier.addProductToCart(
            widget.product, 1, lang, {},
            onProcess: _onAdding,
            onSuccess: _onAddSuccess,
            onFailure: _onAddFailure);
      } else {
        _flushBarService.showErrorDialog(
            'out_of_stock_error'.tr(), "no_qty.svg");
      }
    }
  }

  _onAdding() {
    _progressService.addingProductProgress();
  }

  void _onAddSuccess() {
    _progressService.hideProgress();
    showSlidingTopSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 0,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return MarkaaCartAddedSuccessDialog(product: widget.product);
          },
        );
      },
    );

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);
  }

  _onAddFailure(String message) {
    _progressService.hideProgress();
    _flushBarService.showErrorDialog(message, "no_qty.svg");
    widget.onAddToCartFailure();
  }

  void _onWishlist() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(
        Preload.navigatorKey.currentContext,
        Routes.product,
        arguments: widget.product,
      );
    } else {
      _addToWishlistController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToWishlistController.stop(canceled: true);
        timer.cancel();
      });
      if (_isWishlist) {
        await Preload.navigatorKey.currentContext
            .read<WishlistChangeNotifier>()
            .removeItemFromWishlist(user.token, widget.product);
      } else {
        await Preload.navigatorKey.currentContext
            .read<WishlistChangeNotifier>()
            .addItemToWishlist(user.token, widget.product, 1, {});
      }
    }
  }
}

class DealClipPath extends CustomClipper<Path> {
  final String lang;

  DealClipPath({this.lang});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (lang == 'ar') {
      path.lineTo(6.w, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    } else {
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - 6.w, size.height / 2);
      path.lineTo(size.width, 0.0);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
