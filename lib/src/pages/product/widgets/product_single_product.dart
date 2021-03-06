import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
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
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../preload.dart';
import 'product_configurable_options.dart';

class ProductSingleProduct extends StatefulWidget {
  final ProductModel product;
  final ProductEntity productDetails;
  final ProductChangeNotifier model;

  ProductSingleProduct({
    required this.product,
    required this.productDetails,
    required this.model,
  });

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct> with TickerProviderStateMixin {
  bool isMore = false;
  bool isFavorite = true;

  int? index;
  int activeIndex = 0;

  AnimationController? _favoriteController;
  Animation<double>? _favoriteScaleAnimation;

  FlushBarService? flushBarService;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  WishlistChangeNotifier? wishlistChangeNotifier;
  MarkaaAppChangeNotifier? markaaAppChangeNotifier;

  ProductEntity get details => widget.model.productDetailsMap[widget.product.productId]!;

  Future preloadImages() async {
    List<dynamic> urls =
        widget.model.selectedVariant != null ? widget.model.selectedVariant?.gallery ?? [] : details.gallery ?? [];
    if (urls.isNotEmpty) {
      for (var url in urls) {
        if (url != null) {
          await DefaultCacheManager().downloadFile(url);
        }
      }
    }
  }

  bool get isWishlist => _checkFavorite();
  bool _checkFavorite() {
    final variant = widget.model.selectedVariant;
    final wishlistItems = wishlistChangeNotifier!.wishlistItemsMap;

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
      return variant.stockQty! > 0;
    }
    return details.stockQty > 0;
  }

  bool get discounted => _checkDiscounted();
  bool _checkDiscounted() {
    final variant = widget.model.selectedVariant;
    return details.discount > 0 || (variant?.discount ?? 0) > 0;
  }

  bool get isValidUrl => _checkUrlValidation();
  bool _checkUrlValidation() {
    final variant = widget.model.selectedVariant;
    return variant!.imageUrl.isNotEmpty;
  }

  int get discountValue => _getDiscountValue();
  int _getDiscountValue() {
    final variant = widget.model.selectedVariant;
    return details.discount > 0 ? details.discount : variant!.discount!;
  }

  int get availableCount => _getAvailableCount();
  int _getAvailableCount() {
    final variant = widget.model.selectedVariant;
    if (variant != null) {
      return variant.stockQty ?? 0;
    }
    return details.stockQty;
  }

  @override
  void initState() {
    super.initState();

    flushBarService = FlushBarService(context: context);
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();

    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _favoriteController!,
      curve: Curves.easeIn,
    ));

    widget.model.addListener(() {
      if (widget.model.selectedVariant != null) {
        if (activeIndex >= widget.model.selectedVariant!.gallery!.length) {
          activeIndex = 0;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _favoriteController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    preloadImages();
    return Stack(
      children: [
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Consumer<ProductChangeNotifier>(
                builder: (_, model, ___) {
                  if (model.selectedVariant != null) {
                    return _buildVariantCarousel();
                  } else {
                    return _buildImageCarousel();
                  }
                },
              ),
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
        if (details.isDeal) ...[_buildDealValueLabel()],
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

  Widget _buildDealValueLabel() {
    return Align(
      alignment: Preload.language == 'en' ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 280.h),
        child: ClipPath(
          clipper: DealClipPath(lang: Preload.language),
          child: Container(
            width: 86.w,
            height: 35.h,
            color: pinkColor,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'deal_label'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
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

  SwiperController _swiperController = SwiperController();
  Widget _buildImageCarousel() {
    return Container(
      width: double.infinity,
      height: 460.h,
      child: Stack(
        children: [
          if (details.gallery == null) ...[
            Container()
          ] else if (details.gallery!.length == 1) ...[
            InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                Routes.viewFullImage,
                arguments: details.gallery,
              ),
              child: CachedNetworkImage(
                imageUrl: details.gallery?[0] ?? '',
                width: designWidth.w,
                height: 420.h,
                errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                progressIndicatorBuilder: (_, __, ___) {
                  return CachedNetworkImage(
                    imageUrl: details.imageUrl,
                    width: designWidth.w,
                    height: 420.h,
                    errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                  );
                },
              ),
            )
          ] else ...[
            Container(
              width: designWidth.w,
              height: 420.h,
              child: Swiper(
                itemCount: details.gallery!.length,
                autoplay: false,
                curve: Curves.easeIn,
                controller: _swiperController,
                duration: 300,
                autoplayDelay: 5000,
                onIndexChanged: (value) {
                  activeIndex = value;
                  markaaAppChangeNotifier!.rebuild();
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.viewFullImage,
                      arguments: details.gallery,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: details.gallery?[index] ?? '',
                      width: designWidth.w,
                      height: 420.h,
                      errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                      progressIndicatorBuilder: (_, __, ___) {
                        if (index == 0) {
                          return CachedNetworkImage(
                            imageUrl: details.imageUrl,
                            width: designWidth.w,
                            height: 420.h,
                            errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                          );
                        }
                        return Container(
                          width: designWidth.w,
                          height: 420.h,
                          alignment: Alignment.center,
                          child: PulseLoadingSpinner(),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  if (details.gallery != null) {
                    return SmoothIndicator(
                      offset: activeIndex.toDouble(),
                      count: details.gallery!.length,
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
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Preload.language == 'en' ? Alignment.bottomRight : Alignment.bottomLeft,
            child: _buildTitlebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCarousel() {
    return Container(
      width: double.infinity,
      height: 460.h,
      child: Stack(
        children: [
          if (widget.model.selectedVariant != null && widget.model.selectedVariant!.gallery!.length == 1) ...[
            InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                Routes.viewFullImage,
                arguments: widget.model.selectedVariant?.gallery ?? [],
              ),
              child: CachedNetworkImage(
                imageUrl: widget.model.selectedVariant?.gallery?[0] ?? '',
                width: designWidth.w,
                height: 420.h,
                errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                progressIndicatorBuilder: (_, __, ___) {
                  return Container(
                    width: designWidth.w,
                    height: 420.h,
                    child: PulseLoadingSpinner(),
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              width: designWidth.w,
              height: 420.h,
              child: Swiper(
                itemCount: widget.model.selectedVariant!.gallery!.length,
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
                      arguments: widget.model.selectedVariant?.gallery ?? [],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.model.selectedVariant?.gallery?[index] ?? '',
                      width: designWidth.w,
                      height: 420.h,
                      errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                      progressIndicatorBuilder: (_, __, ___) {
                        return Container(
                          width: designWidth.w,
                          height: 420.h,
                          child: PulseLoadingSpinner(),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.model.selectedVariant!.gallery!.length,
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
            alignment: Preload.language == 'en' ? Alignment.bottomRight : Alignment.bottomLeft,
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
                onTap: () => user != null ? _onFavorite(widget.model) : Navigator.pushNamed(context, Routes.signIn),
                child: ScaleTransition(
                  scale: _favoriteScaleAnimation!,
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    child: SvgPicture.asset(isWishlist ? wishlistedIcon : favoriteIcon),
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
                      category: null,
                      subCategory: [],
                      brand: details.brandEntity,
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                  },
                  child: Text(
                    details.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: Preload.language == 'en' ? 16.sp : 18.sp,
                    ),
                  ),
                ),
              ),
              _buildProductPrice(),
            ],
          ),
          Text(details.name, style: mediumTextStyle.copyWith(fontSize: 20.sp)),
        ],
      ),
    );
  }

  Widget _buildStock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isStock ? 'in_stock'.tr().toUpperCase() : 'out_stock'.tr().toUpperCase(),
          style: mediumTextStyle.copyWith(
            color: isStock ? succeedColor : dangerColor,
            fontSize: Preload.language == 'en' ? 14.sp : 18.sp,
          ),
        ),
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

  Widget _buildPrice() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'sku'.tr() + ': ' + details.sku,
              style: mediumTextStyle.copyWith(fontSize: 12.sp, color: primaryColor),
            ),
          ),
          _buildStock(),
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
            (widget.model.selectedVariant?.beforePrice ?? details.beforePrice ?? '') + ' ' + 'currency'.tr(),
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
              widget.model.selectedVariant != null ? widget.model.selectedVariant!.price : details.price,
              style: mediumTextStyle.copyWith(fontSize: 18.sp, color: greyColor),
            ),
            SizedBox(width: 1.w),
            Text(
              'currency'.tr(),
              style: mediumTextStyle.copyWith(fontSize: 12.sp, color: greyColor),
            )
          ],
        ),
      ],
    );
  }

  _onFavorite(ProductChangeNotifier model) async {
    if (model.productDetails!.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length != model.productDetails!.configurable!.keys.toList().length) {
      flushBarService!.showErrorDialog(
        'required_options'.tr(),
        "select_option.svg",
      );
      return;
    }
    if (model.productDetails!.typeId == 'configurable' && (model.selectedVariant!.stockQty == 0)) {
      flushBarService!.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      return;
    }
    _updateWishlist(model);
    _favoriteController!.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _favoriteController!.stop(canceled: true);
      timer.cancel();
    });
  }

  _updateWishlist(ProductChangeNotifier model) async {
    if (isWishlist) {
      await wishlistChangeNotifier!.removeItemFromWishlist(user!.token, widget.product, widget.model.selectedVariant);
    } else {
      await wishlistChangeNotifier!
          .addItemToWishlist(user!.token, widget.product, 1, model.selectedOptions, widget.model.selectedVariant);
    }
  }

  _onShareProduct() async {
    Uri shareLink = await dynamicLinkService.productSharableLink(widget.product);
    Share.share(shareLink.toString(), subject: details.name);
  }
}
