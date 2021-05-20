import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
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

class _ProductSingleProductState extends State<ProductSingleProduct> with TickerProviderStateMixin {
  bool isMore = false;
  int activeIndex = 0;
  bool isFavorite = true;
  bool isWishlist = false;
  int index;
  AnimationController _favoriteController;
  Animation<double> _favoriteScaleAnimation;
  FlushBarService flushBarService;
  WishlistChangeNotifier wishlistChangeNotifier;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  bool get isStock =>
      widget.model.productDetailsMap[widget.product.productId].stockQty != null &&
      widget.model.productDetailsMap[widget.product.productId].stockQty > 0;

  List<CachedNetworkImage> get preCachedImages => _loadCacheImages();

  List<CachedNetworkImage> _loadCacheImages() {
    final productEntity = widget.model.productDetailsMap[widget.product.productId];
    final List<CachedNetworkImage> list = [];
    if (productEntity?.gallery != null && productEntity.gallery.isNotEmpty) {
      for (int i = 0; i < productEntity.gallery.length; i++) {
        list.add(CachedNetworkImage(
          imageUrl: productEntity.gallery[i],
          width: designWidth.w,
          height: 400.h,
          fit: BoxFit.fitHeight,
          // loadingBuilder: (_, child, chunk) {
          //   if (chunk != null) {
          //     return Center(
          //       child: CupertinoActivityIndicator(
          //         radius: 30.sp,
          //       ),
          //     );
          //   }
          //   return child;
          // },
        ));
      }
    }
    if (list.isNotEmpty) {
      // for (var item in list) {
      //   precacheImage(item.image, context);
      // }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    _initFavorite();
    _initAnimation();
  }

  @override
  void didChangeDependencies() {
    print('>>> update dependencies');
    super.didChangeDependencies();
  }

  void _initFavorite() async {
    if (user?.token != null) {
      isWishlist = wishlistIds.contains(widget.model.productDetailsMap[widget.product.productId].productId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _initAnimation() {
    /// favorite button animation
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
              if (widget?.model?.selectedVariant?.productId != null) ...[
                Container(
                  width: double.infinity,
                  height: 460.h,
                  child: widget?.model?.selectedVariant?.imageUrl != null && widget.model.selectedVariant.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget?.model?.selectedVariant?.imageUrl,
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                        )
                      : null,
                )
              ] else if (preCachedImages.isNotEmpty) ...[
                _buildImageCarousel()
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    _buildTitle(),
                    _buildDescription(),
                    _buildPrice(),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.model.productDetailsMap[widget.product.productId].discount > 0 ||
            (widget?.model?.selectedVariant?.discount != null && widget.model.selectedVariant.discount > 0)) ...[
          if (Preload.language == 'en') ...[
            Positioned(
              top: 320.h,
              right: 0,
              child: _buildDiscount(),
            ),
          ] else ...[
            Positioned(
              top: 320.h,
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
        '${widget.model.productDetailsMap[widget.product.productId].discount > 0 ? widget.model.productDetailsMap[widget.product.productId].discount : widget.model.selectedVariant.discount}%',
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: 16.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTitlebar() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 26.w,
              height: 26.h,
              child: SvgPicture.asset(
                Preload.language == 'en' ? arrowBackEnIcon : arrowBackArIcon,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, right: 20.w, left: 20.w),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.myCart),
                  child: Center(
                    child: Consumer<MyCartChangeNotifier>(
                      builder: (_, model, __) {
                        return Badge(
                          badgeColor: badgeColor,
                          badgeContent: Text(
                            '${model.cartTotalCount}',
                            style: TextStyle(fontSize: 8.sp, color: Colors.white),
                          ),
                          showBadge: model.cartItemCount > 0,
                          toAnimate: false,
                          animationDuration: Duration.zero,
                          position: Preload.languageCode == 'ar'
                              ? BadgePosition.topStart(
                                  start: 0,
                                  top: -2.h,
                                )
                              : BadgePosition.topEnd(
                                  end: 0,
                                  top: -2.h,
                                ),
                          child: SvgPicture.asset(addCart1Icon),
                        );
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _onShareProduct(),
                icon: SvgPicture.asset(shareIcon),
              ),
              Consumer<WishlistChangeNotifier>(
                builder: (_, model, __) {
                  isWishlist = model.wishlistItemsMap.containsKey(widget.model.productDetailsMap[widget.product.productId].productId);
                  if (widget.model.productDetailsMap[widget.product.productId].typeId == 'configurable') {
                    isWishlist = widget?.model?.selectedVariant != null && model.wishlistItemsMap.containsKey(widget.model.selectedVariant.productId);
                    print('wishlist $isWishlist');
                  }
                  return IconButton(
                    onPressed: () => user != null ? _onFavorite(widget.model) : Navigator.pushNamed(context, Routes.signIn),
                    icon: ScaleTransition(
                      scale: _favoriteScaleAnimation,
                      child: Container(
                        width: 26.w,
                        height: 26.h,
                        child: SvgPicture.asset(
                          isWishlist ? wishlistedIcon : favoriteIcon,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
              padding: EdgeInsets.only(
                bottom: 20.h,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.model.productDetailsMap[widget.product.productId].gallery.length,
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
          _buildTitlebar(),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: widget.model.productDetailsMap[widget.product.productId].brandEntity,
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: widget.model.productDetailsMap[widget.product.productId]?.brandEntity != null
                      ? Text(
                          widget.model.productDetailsMap[widget.product.productId]?.brandEntity?.brandLabel ?? '',
                          style: mediumTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: Preload.language == 'en' ? 16.sp : 18.sp,
                          ),
                        )
                      : Container(),
                ),
              ),
              Text(
                widget.model.productDetailsMap[widget.product.productId]?.brandEntity == null
                    ? ''
                    : isStock
                        ? 'in_stock'.tr().toUpperCase()
                        : 'out_stock'.tr().toUpperCase(),
                style: mediumTextStyle.copyWith(
                  color: isStock ? succeedColor : dangerColor,
                  fontSize: Preload.language == 'en' ? 14.sp : 18.sp,
                ),
              ),
            ],
          ),
          Text(
            widget.model.productDetailsMap[widget.product.productId].name,
            style: mediumTextStyle.copyWith(
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  SwiperController _swiperController = SwiperController();
  Widget _buildProduct() {
    return Container(
      width: designWidth.w,
      height: 420.h,
      child: preCachedImages.length == 1
          ? preCachedImages[0]
          : Swiper(
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
                    arguments: widget.model.productDetailsMap[widget.product.productId].gallery,
                  ),
                  child: preCachedImages[index],
                );
              },
            ),
    );
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
              widget.model.productDetailsMap[widget.product.productId].shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ] else if (isLength(widget.model.productDetailsMap[widget.product.productId].shortDescription, 110)) ...[
            Text(
              widget.model.productDetailsMap[widget.product.productId].shortDescription.substring(0, 110) + ' ...',
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ] else ...[
            Text(
              widget.model.productDetailsMap[widget.product.productId].shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            )
          ],
          if (isLength(widget.model.productDetailsMap[widget.product.productId].shortDescription, 110)) ...[
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'sku'.tr() + ': ' + widget.model.productDetailsMap[widget.product.productId].sku,
            style: mediumTextStyle.copyWith(
              fontSize: 12.sp,
              color: primaryColor,
            ),
          ),
          Row(
            children: [
              if (widget.model.productDetailsMap[widget.product.productId].discount > 0 ||
                  (widget?.model?.selectedVariant?.discount != null && widget.model.selectedVariant.discount > 0)) ...[
                SizedBox(width: 10.w),
                Text(
                  (widget.model.productDetailsMap[widget.product.productId].beforePrice ?? widget.model.selectedVariant.beforePrice) +
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
                    widget.model.productDetailsMap[widget.product.productId].price != null
                        ? widget.model.productDetailsMap[widget.product.productId].price
                        : widget?.model?.selectedVariant?.price != null
                            ? widget.model.selectedVariant.price
                            : '',
                    style: mediumTextStyle.copyWith(
                      fontSize: 20.sp,
                      color: greyColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  if (widget.model.productDetailsMap[widget.product.productId].price != null || widget?.model?.selectedVariant?.price != null) ...[
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
          ),
        ],
      ),
    );
  }

  void _onFavorite(ProductChangeNotifier model) async {
    if (model.productDetails.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length != model.productDetails.configurable.keys.toList().length) {
      flushBarService.showErrorMessage('required_options'.tr());
      return;
    }
    if (model.productDetails.typeId == 'configurable' && (model?.selectedVariant?.stockQty == null || model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorMessage('out_of_stock_error'.tr());
      return;
    }
    _updateWishlist(model);
    _favoriteController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _favoriteController.stop(canceled: true);
      timer.cancel();
    });
  }

  void _updateWishlist(ProductChangeNotifier model) async {
    if (isWishlist) {
      await wishlistChangeNotifier.removeItemFromWishlist(user.token, widget.product, widget.model.selectedVariant);
    } else {
      await wishlistChangeNotifier.addItemToWishlist(user.token, widget.product, 1, model.selectedOptions, widget.model.selectedVariant);
    }
  }

  void _onShareProduct() async {
    Uri shareLink = await dynamicLinkService.productSharableLink(widget.product);
    Share.share(shareLink.toString(), subject: widget.model.productDetailsMap[widget.product.productId].name);
  }
}
