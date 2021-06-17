import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../preload.dart';
import 'product_configurable_options.dart';

class ProductSingleProduct extends StatefulWidget {
  final ProductModel product;
  final ProductEntity productDetails;
  final ProductChangeNotifier model;

  ProductSingleProduct({
    @required this.product,
    @required this.productDetails,
    @required this.model,
  });

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct>
    with TickerProviderStateMixin {
  bool isMore = false;
  bool isFavorite = true;

  int index;
  int activeIndex = 0;

  AnimationController _favoriteController;
  Animation<double> _favoriteScaleAnimation;

  FlushBarService flushBarService;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  WishlistChangeNotifier wishlistChangeNotifier;

  ProductEntity get details =>
      widget.model.productDetailsMap[widget.product.productId];

  bool get isWishlist => _checkFavorite();
  bool _checkFavorite() {
    final variant = widget.model.selectedVariant;
    final wishlistItems = wishlistChangeNotifier.wishlistItemsMap;

    bool favorite = false;
    if (details.typeId == 'configurable') {
      favorite = wishlistItems.containsKey(variant?.productId ?? '');
    } else {
      favorite = wishlistItems.containsKey(details.productId);
    }
    return favorite;
  }

  bool get isStock => _checkStockAvailability();
  bool _checkStockAvailability() {
    final variant = widget.model.selectedVariant;

    if (variant != null) {
      return variant.stockQty != null && variant.stockQty > 0;
    }
    return details.stockQty != null && details.stockQty > 0;
  }

  bool get discounted => _checkDiscounted();
  bool _checkDiscounted() {
    final variant = widget.model.selectedVariant;

    return details.discount > 0 ||
        variant?.discount != null && variant.discount > 0;
  }

  bool get isValidUrl => _checkUrlValidation();
  bool _checkUrlValidation() {
    final variant = widget.model.selectedVariant;

    return variant?.imageUrl != null && variant.imageUrl.isNotEmpty;
  }

  int get discountValue => _getDiscountValue();
  int _getDiscountValue() {
    final variant = widget.model.selectedVariant;

    return details.discount > 0 ? details.discount : variant.discount;
  }

  int get availableCount => _getAvailableCount();
  int _getAvailableCount() {
    final variant = widget.model.selectedVariant;

    if (variant != null) {
      return variant.stockQty ?? 0;
    }
    return details.stockQty ?? 0;
  }

  List<CachedNetworkImage> get preCachedImages => _loadCacheImages();
  List<CachedNetworkImage> _loadCacheImages() {
    List<CachedNetworkImage> list = [];

    if (details?.gallery != null && details.gallery.isNotEmpty) {
      for (int i = 0; i < details.gallery.length; i++) {
        if (i == 0 && details.gallery[0] != details.imageUrl) {
          list.add(CachedNetworkImage(
            imageUrl: details.gallery[i],
            width: designWidth.w,
            height: 400.h,
            fit: BoxFit.fitHeight,
            progressIndicatorBuilder: (_, __, ___) {
              return CachedNetworkImage(
                imageUrl: details.imageUrl,
                width: designWidth.w,
                height: 400.h,
                fit: BoxFit.fitHeight,
              );
            },
          ));
        } else {
          list.add(CachedNetworkImage(
            imageUrl: details.gallery[i],
            width: designWidth.w,
            height: 400.h,
            fit: BoxFit.fitHeight,
          ));
        }
      }
    }

    return list;
  }

  @override
  void initState() {
    super.initState();

    flushBarService = FlushBarService(context: context);
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();

    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              if (widget?.model?.selectedVariant?.productId != null) ...[
                if (isValidUrl) ...[
                  Container(
                    width: double.infinity,
                    height: 460.h,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget?.model?.selectedVariant?.imageUrl,
                          width: designWidth.w,
                          height: 400.h,
                          fit: BoxFit.fitHeight,
                          errorWidget: (context, url, error) {
                            return Center(child: Icon(Icons.image, size: 20));
                          },
                        ),
                        Align(
                          alignment: Preload.language == 'en'
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: _buildTitlebar(),
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  Container(
                    width: designWidth.w,
                    height: 460.h,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Preload.language == 'en'
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: _buildTitlebar(),
                        ),
                      ],
                    ),
                  )
                ],
              ] else if (preCachedImages.isNotEmpty) ...[
                _buildImageCarousel()
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    _buildTitle(),
                    if (details.typeId == 'configurable') ...[
                      ProductConfigurableOptions(
                        productEntity: details,
                        model: widget.model,
                      )
                    ] else ...[
                      _buildDescription()
                    ],
                    _buildPrice(),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (discounted) ...[
          if (Preload.language == 'en') ...[
            Positioned(
              top: 280.h,
              right: 0,
              child: _buildDiscount(),
            ),
          ] else ...[
            Positioned(
              top: 280.h,
              left: 0,
              child: _buildDiscount(),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildDiscount() {
    return Container(
      width: 60.w,
      height: 35.h,
      decoration: BoxDecoration(color: Colors.redAccent),
      alignment: Alignment.center,
      child: Text(
        '$discountValue%',
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: 16.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      width: double.infinity,
      height: 460.h,
      child: Stack(
        children: [
          _buildProduct(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: details.gallery.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 30,
                  dotWidth: 8.h,
                  dotHeight: 8.h,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: greyLightColor,
                  activeDotColor: primarySwatchColor,
                ),
              ),
            ),
          ),
          Align(
            alignment: Preload.language == 'en'
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            child: _buildTitlebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitlebar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => _onShareProduct(),
            child: SvgPicture.asset(shareIcon, width: 28.w, height: 28.h),
          ),
          SizedBox(height: 10.h),
          Consumer<WishlistChangeNotifier>(
            builder: (_, model, __) {
              return InkWell(
                onTap: () => user != null
                    ? _onFavorite(widget.model)
                    : Navigator.pushNamed(context, Routes.signIn),
                child: ScaleTransition(
                  scale: _favoriteScaleAnimation,
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    child: SvgPicture.asset(
                      isWishlist ? wishlistedIcon : favoriteIcon,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 45.h),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: details.brandEntity,
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: Text(
                    details?.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: Preload.language == 'en' ? 16.sp : 18.sp,
                    ),
                  ),
                ),
              ),
              if (details.typeId == 'configurable') ...[
                _buildProductPrice()
              ] else ...[
                _buildStock()
              ],
            ],
          ),
          Text(
            details.name,
            style: mediumTextStyle.copyWith(fontSize: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildStock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (details?.brandEntity != null) ...[
          Text(
            isStock
                ? 'in_stock'.tr().toUpperCase()
                : 'out_stock'.tr().toUpperCase(),
            style: mediumTextStyle.copyWith(
              color: isStock ? succeedColor : dangerColor,
              fontSize: Preload.language == 'en' ? 14.sp : 18.sp,
            ),
          ),
        ],
        if (isStock && availableCount == 1) ...[
          Text(
            'stock_count'.tr().replaceFirst('#', '$availableCount'),
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: Preload.language == 'en' ? 10.sp : 12.sp,
            ),
          ),
        ]
      ],
    );
  }

  SwiperController _swiperController = SwiperController();
  Widget _buildProduct() {
    if (preCachedImages.length == 1) {
      return Container(
        width: designWidth.w,
        height: 420.h,
        child: preCachedImages[0],
      );
    } else {
      return Container(
        width: designWidth.w,
        height: 420.h,
        child: Swiper(
          itemCount: preCachedImages.length,
          autoplay: false,
          curve: Curves.easeIn,
          controller: _swiperController,
          duration: 300,
          autoplayDelay: 5000,
          onIndexChanged: (value) {
            setState(() {
              activeIndex = value;
            });
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                Routes.viewFullImage,
                arguments: details.gallery,
              ),
              child: preCachedImages[index],
            );
          },
        ),
      );
    }
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMore) ...[
            Text(
              details.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ] else if (isLength(details.shortDescription, 110)) ...[
            Text(
              details.shortDescription.substring(0, 110) + ' ...',
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ] else ...[
            Text(
              details.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ],
          if (isLength(details.shortDescription, 110)) ...[
            InkWell(
              onTap: () {
                isMore = !isMore;
                setState(() {});
              },
              child: Text(
                isMore ? 'product_less'.tr() : 'product_more'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            )
          ] else ...[
            SizedBox.shrink()
          ],
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'sku'.tr() + ': ' + details.sku,
              style: mediumTextStyle.copyWith(
                fontSize: 12.sp,
                color: primaryColor,
              ),
            ),
          ),
          if (details.typeId == 'configurable') ...[
            _buildStock()
          ] else ...[
            _buildProductPrice()
          ],
        ],
      ),
    );
  }

  Widget _buildProductPrice() {
    return Row(
      children: [
        if (discounted) ...[
          SizedBox(width: 10.w),
          Text(
            (widget.model.selectedVariant?.beforePrice ?? details.beforePrice) +
                ' ' +
                'currency'.tr(),
            style: mediumTextStyle.copyWith(
              decorationStyle: TextDecorationStyle.solid,
              decoration: TextDecoration.lineThrough,
              decorationColor: dangerColor,
              fontSize: 14.sp,
              color: greyColor,
            ),
          ),
          SizedBox(width: 10.w),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget?.model?.selectedVariant?.price != null
                  ? widget.model.selectedVariant.price
                  : details.price != null
                      ? details.price
                      : '',
              style: mediumTextStyle.copyWith(
                fontSize: 18.sp,
                color: greyColor,
                // fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 1.w),
            if (details.price != null ||
                widget?.model?.selectedVariant?.price != null) ...[
              Text(
                'currency'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 12.sp,
                  color: greyColor,
                ),
              )
            ],
          ],
        ),
      ],
    );
  }

  _onFavorite(ProductChangeNotifier model) async {
    if (model.productDetails.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length !=
            model.productDetails.configurable.keys.toList().length) {
      flushBarService.showErrorDialog('required_options'.tr(), "no_qty.svg");
      return;
    }
    if (model.productDetails.typeId == 'configurable' &&
        (model?.selectedVariant?.stockQty == null ||
            model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      return;
    }
    _updateWishlist(model);
    _favoriteController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _favoriteController.stop(canceled: true);
      timer.cancel();
    });
  }

  _updateWishlist(ProductChangeNotifier model) async {
    if (isWishlist) {
      await wishlistChangeNotifier.removeItemFromWishlist(
          user.token, widget.product, widget.model.selectedVariant);
    } else {
      await wishlistChangeNotifier.addItemToWishlist(user.token, widget.product,
          1, model.selectedOptions, widget.model.selectedVariant);
    }
  }

  _onShareProduct() async {
    Uri shareLink =
        await dynamicLinkService.productSharableLink(widget.product);
    Share.share(shareLink.toString(), subject: details.name);
  }
}
