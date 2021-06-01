import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/custom/sliding_sheet.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
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
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductVVCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isLine;
  final bool isMinor;
  final bool isPrimary;

  ProductVVCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isLine = false,
    this.isMinor = true,
    this.isPrimary = true,
  });

  @override
  _ProductVVCardState createState() => _ProductVVCardState();
}

class _ProductVVCardState extends State<ProductVVCard> with TickerProviderStateMixin {
  bool isWishlist;
  int index;

  FlushBarService flushBarService;
  ProgressService progressService;

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
            width: widget.cardHeight * 0.65,
            height: widget.cardHeight * 0.6,
            fit: BoxFit.fitHeight,
            errorWidget: (context, url, error) {
              return Center(child: Icon(Icons.image, size: 20.sp));
            },
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
                        widget.product.price != null ? (widget.product.price + ' ' + 'currency'.tr()) : '',
                        style: mediumTextStyle.copyWith(
                          fontSize: widget.isMinor ? 12.sp : 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.product.discount > 0) ...[
                        SizedBox(width: widget.isMinor ? 4.w : 10.w),
                        Text(
                          widget.product.beforePrice + ' ' + 'currency'.tr(),
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
                if (widget.isShoppingCart &&
                    (widget.product.typeId != 'simple' || widget.product.stockQty != null && widget.product.stockQty > 0)) ...[
                  if (widget.isPrimary) ...[
                    ScaleTransition(
                      scale: _addToCartScaleAnimation,
                      child: Container(
                        width: widget.cardWidth - 16.w,
                        height: 35.h,
                        child: MarkaaTextButton(
                          title: 'wishlist_add_cart_button_title'.tr(),
                          titleColor: Colors.white,
                          titleSize: 14.sp,
                          borderColor: Colors.transparent,
                          buttonColor: primaryColor,
                          onPressed: () => _onAddProductToCart(),
                        ),
                      ),
                    )
                  ] else ...[
                    Consumer<MarkaaAppChangeNotifier>(
                      builder: (_, model, __) {
                        return ScaleTransition(
                          scale: _addToCartScaleAnimation,
                          child: Container(
                            width: widget.cardWidth,
                            height: 35.h,
                            child: MarkaaTextIconButton(
                              title: 'wishlist_add_cart_button_title'.tr(),
                              titleColor: primaryColor,
                              titleSize: 14.sp,
                              icon: SvgPicture.asset(addCart1Icon, width: 24.w),
                              leading: false,
                              borderColor: Colors.transparent,
                              buttonColor: Colors.white,
                              onPressed: () {
                                if (model.activeAddCart) {
                                  model.changeAddCartStatus(false);
                                  _onAddProductToCart();
                                  model.changeAddCartStatus(true);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ]
                ] else ...[
                  SizedBox.shrink()
                ],
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
    });
  }

  Widget _buildOutofStock() {
    if (widget.product.typeId == 'simple' && (widget.product.stockQty == null || widget.product.stockQty == 0)) {
      return Align(
        alignment: lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
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
      Navigator.pushNamed(context, Routes.product, arguments: widget.product);
    } else {
      _addToCartController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _addToCartController.stop(canceled: true);
        timer.cancel();
      });

      if (widget.product.stockQty != null && widget.product.stockQty > 0) {
        await myCartChangeNotifier.addProductToCart(widget.product, 1, lang, {},
            onProcess: _onAdding, onSuccess: _onAddSuccess, onFailure: _onAddFailure);
      } else {
        flushBarService.showSimpleErrorMessageWithImage('out_of_stock_error'.tr(), "no_qty.svg");
      }
    }
  }

  _onAdding() {
    progressService.addingProductProgress();
  }

  void _onAddSuccess() {
    progressService.hideProgress();
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
    progressService.hideProgress();
    flushBarService.showSimpleErrorMessageWithImage(message, "no_qty.svg");
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
