import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
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
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../config.dart';

class ProductSingleProduct extends StatefulWidget {
  final ProductModel product;
  final ProductChangeNotifier model;

  ProductSingleProduct({
    this.product,
    this.model,
  });

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct> with TickerProviderStateMixin {
  bool isMore = false;
  int activeIndex = 0;
  bool isFavorite = true;
  bool isWishlist = false;
  bool isStock = true;
  int index;
  AnimationController _favoriteController;
  Animation<double> _favoriteScaleAnimation;
  ProductModel product;
  FlushBarService flushBarService;
  WishlistChangeNotifier wishlistChangeNotifier;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  @override
  void initState() {
    super.initState();
    product = widget.product;
    isStock = widget.model.productDetails.stockQty != null && widget.model.productDetails.stockQty > 0;
    flushBarService = FlushBarService(context: context);
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    _initFavorite();
    _initAnimation();
  }

  void _initFavorite() async {
    if (user?.token != null) {
      isWishlist = wishlistIds.contains(product.productId);
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
    print("widget.model.productDetails.gallery.length ${widget.model.productDetails.gallery.length}");
    return Stack(
      children: [
        Container(
          width: Config.pageStyle.deviceWidth,
          color: Colors.white,
          child: Column(
            children: [
              if (widget?.model?.selectedVariant?.productId != null) ...[
                Container(
                  width: double.infinity,
                  height: Config.pageStyle.unitHeight * 460,
                  child: widget?.model?.selectedVariant?.imageUrl != null && widget.model.selectedVariant.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget?.model?.selectedVariant?.imageUrl,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                        )
                      : null,
                )
              ] else if (widget.model.productDetails.gallery.isNotEmpty) ...[
                _buildImageCarousel()
              ],
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Config.pageStyle.unitWidth * 10,
                ),
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
        if (widget.model.productDetails.discount > 0 ||
            (widget?.model?.selectedVariant?.discount != null && widget.model.selectedVariant.discount > 0)) ...[
          if (Config.language == 'en') ...[
            Positioned(
              top: Config.pageStyle.unitHeight * 320,
              right: 0,
              child: _buildDiscount(),
            ),
          ] else ...[
            Positioned(
              top: Config.pageStyle.unitHeight * 320,
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
      width: Config.pageStyle.unitWidth * 60,
      height: Config.pageStyle.unitHeight * 35,
      decoration: BoxDecoration(color: Colors.redAccent),
      alignment: Alignment.center,
      child: Text(
        '${widget.model.productDetails.discount > 0 ? widget.model.productDetails.discount : widget.model.selectedVariant.discount}%',
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: Config.pageStyle.unitFontSize * 16,
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
              width: Config.pageStyle.unitWidth * 26,
              height: Config.pageStyle.unitHeight * 26,
              child: SvgPicture.asset(
                Config.language == 'en' ? arrowBackEnIcon : arrowBackArIcon,
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _onShareProduct(),
                icon: SvgPicture.asset(shareIcon),
              ),
              Consumer<WishlistChangeNotifier>(
                builder: (_, model, __) {
                  isWishlist = model.wishlistItemsMap.containsKey(widget.product.productId);
                  if (widget.model.productDetails.typeId == 'configurable') {
                    isWishlist = widget?.model?.selectedVariant != null && model.wishlistItemsMap.containsKey(widget.model.selectedVariant.productId);
                    print('wishlist $isWishlist');
                  }
                  return IconButton(
                    onPressed: () => user != null ? _onFavorite(widget.model) : Navigator.pushNamed(context, Routes.signIn),
                    icon: ScaleTransition(
                      scale: _favoriteScaleAnimation,
                      child: Container(
                        width: Config.pageStyle.unitWidth * 26,
                        height: Config.pageStyle.unitHeight * 26,
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
      height: Config.pageStyle.unitHeight * 460,
      child: Stack(
        children: [
          _buildProduct(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Config.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.model.productDetails.gallery.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 30,
                  dotWidth: Config.pageStyle.unitHeight * 8,
                  dotHeight: Config.pageStyle.unitHeight * 8,
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
              if (widget.model.productDetails?.brandEntity != null) ...[
                InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: widget.model.productDetails.brandEntity,
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
                    widget.model.productDetails?.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: Config.pageStyle.unitFontSize * (Config.language == 'en' ? 16 : 18),
                    ),
                  ),
                )
              ],
              Text(
                isStock ? 'in_stock'.tr().toUpperCase() : 'out_stock'.tr().toUpperCase(),
                style: mediumTextStyle.copyWith(
                  color: isStock ? succeedColor : dangerColor,
                  fontSize: Config.pageStyle.unitFontSize * (Config.language == 'en' ? 14 : 18),
                ),
              ),
            ],
          ),
          Text(
            widget.model.productDetails.name,
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 420,
      child: Swiper(
        itemCount: widget.model.productDetails.gallery.length,
        autoplay: false,
        curve: Curves.easeIn,
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
              arguments: widget.model.productDetails.gallery,
            ),
            child: CachedNetworkImage(
              imageUrl: widget.model.productDetails.gallery[index],
              width: Config.pageStyle.deviceWidth,
              height: Config.pageStyle.unitHeight * 400,
              fit: BoxFit.fitHeight,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMore) ...[
            Text(
              widget.model.productDetails.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: Config.pageStyle.unitFontSize * 14,
              ),
            )
          ] else if (isLength(widget.model.productDetails.shortDescription, 110)) ...[
            Text(
              widget.model.productDetails.shortDescription.substring(0, 110) + ' ...',
              style: mediumTextStyle.copyWith(
                fontSize: Config.pageStyle.unitFontSize * 14,
              ),
            )
          ] else ...[
            Text(
              widget.model.productDetails.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: Config.pageStyle.unitFontSize * 14,
              ),
            )
          ],
          if (isLength(widget.model.productDetails.shortDescription, 110)) ...[
            InkWell(
              onTap: () {
                isMore = !isMore;
                setState(() {});
              },
              child: Text(
                isMore ? 'product_less'.tr() : 'product_more'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: Config.pageStyle.unitFontSize * 14,
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
            'sku'.tr() + ': ' + widget.model.productDetails.sku,
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 12,
              color: primaryColor,
            ),
          ),
          Row(
            children: [
              if (widget.model.productDetails.discount > 0 ||
                  (widget?.model?.selectedVariant?.discount != null && widget.model.selectedVariant.discount > 0)) ...[
                SizedBox(width: Config.pageStyle.unitWidth * 10),
                Text(
                  (widget.model.productDetails.beforePrice ?? widget.model.selectedVariant.beforePrice) + ' ' + 'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    decorationStyle: TextDecorationStyle.solid,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: dangerColor,
                    fontSize: Config.pageStyle.unitFontSize * 14,
                    color: greyColor,
                  ),
                ),
                SizedBox(width: Config.pageStyle.unitWidth * 10),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.model.productDetails.price != null
                        ? widget.model.productDetails.price
                        : widget?.model?.selectedVariant?.price != null
                            ? widget.model.selectedVariant.price
                            : '',
                    style: mediumTextStyle.copyWith(
                      fontSize: Config.pageStyle.unitFontSize * 20,
                      color: greyColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: Config.pageStyle.unitWidth * 1),
                  if (product.price != null || widget?.model?.selectedVariant?.price != null) ...[
                    Text(
                      'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: Config.pageStyle.unitFontSize * 12,
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
      flushBarService.showErrorMessage(Config.pageStyle, 'required_options'.tr());
      return;
    }
    if (model.productDetails.typeId == 'configurable' && (model?.selectedVariant?.stockQty == null || model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorMessage(Config.pageStyle, 'out_of_stock_error'.tr());
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
    Share.share(shareLink.toString(), subject: product.name);
  }
}
