import 'dart:async';

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
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/dynamic_link_service.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_validator/string_validator.dart';

class ProductSingleProduct extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductModel product;
  final ProductEntity productEntity;
  final ProductChangeNotifier model;

  ProductSingleProduct({
    this.pageStyle,
    this.product,
    this.productEntity,
    this.model,
  });

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct>
    with TickerProviderStateMixin {
  bool isMore = false;
  int activeIndex = 0;
  bool isFavorite = true;
  bool isWishlist = false;
  bool isStock = true;
  int index;
  AnimationController _favoriteController;
  Animation<double> _favoriteScaleAnimation;
  ProductModel product;
  ProductEntity productEntity;
  PageStyle pageStyle;
  FlushBarService flushBarService;
  WishlistChangeNotifier wishlistChangeNotifier;
  DynamicLinkService dynamicLinkService = DynamicLinkService();
  List<Image> preCachedImages = [];

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;
    productEntity = widget.productEntity;
    isStock = productEntity.stockQty != null && productEntity.stockQty > 0;
    flushBarService = FlushBarService(context: context);
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    _initFavorite();
    _initAnimation();
  }

  @override
  void didChangeDependencies() {
    if (productEntity.gallery.isNotEmpty) {
      for (int i = 0; i < productEntity.gallery.length; i++) {
        preCachedImages.add(Image.network(
          productEntity.gallery[i],
          width: widget.pageStyle.deviceWidth,
          height: pageStyle.unitHeight * 400,
          fit: BoxFit.fitHeight,
          loadingBuilder: (_, child, chunk) {
            if (chunk != null) {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: pageStyle.unitWidth * 30,
                ),
              );
            }
            return child;
          },
        ));
      }
    }
    if (preCachedImages.isNotEmpty) {
      for (var item in preCachedImages) {
        precacheImage(item.image, context);
      }
    }
    super.didChangeDependencies();
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
    return Container(
      width: pageStyle.deviceWidth,
      color: Colors.white,
      child: Column(
        children: [
          if (preCachedImages.isNotEmpty) ...[
            _buildImageCarousel()
          ] else if (productEntity.gallery.isNotEmpty) ...[
            Container(
              width: double.infinity,
              height: pageStyle.unitHeight * 460,
              alignment: Alignment.center,
              color: Colors.white,
              child: CupertinoActivityIndicator(
                radius: pageStyle.unitWidth * 30,
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              height: pageStyle.unitHeight * 460,
              child: Image.asset('lib/public/images/loading/image_loading.jpg'),
            )
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
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
              width: pageStyle.unitWidth * 26,
              height: pageStyle.unitHeight * 26,
              child: SvgPicture.asset(
                  lang == 'en' ? arrowBackEnIcon : arrowBackArIcon),
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
                  isWishlist = model.wishlistItemsMap
                      .containsKey(widget.product.productId);
                  if (productEntity.typeId == 'configurable') {
                    isWishlist = widget?.model?.selectedVariant != null &&
                        model.wishlistItemsMap.containsKey(
                            widget.model.selectedVariant.productId);
                    print('wishlist $isWishlist');
                  }
                  return IconButton(
                    onPressed: () => user != null
                        ? _onFavorite(widget.model)
                        : Navigator.pushNamed(context, Routes.signIn),
                    icon: ScaleTransition(
                      scale: _favoriteScaleAnimation,
                      child: Container(
                        width: pageStyle.unitWidth * 26,
                        height: pageStyle.unitHeight * 26,
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
      height: widget.pageStyle.unitHeight * 460,
      child: Stack(
        children: [
          _buildProduct(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: widget.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: productEntity.gallery.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 30,
                  dotWidth: widget.pageStyle.unitHeight * 8,
                  dotHeight: widget.pageStyle.unitHeight * 8,
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
              if (productEntity?.brandEntity != null) ...[
                InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: productEntity.brandEntity,
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
                    productEntity?.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize:
                          pageStyle.unitFontSize * (lang == 'en' ? 16 : 18),
                    ),
                  ),
                )
              ],
              Text(
                isStock
                    ? 'in_stock'.tr().toUpperCase()
                    : 'out_stock'.tr().toUpperCase(),
                style: mediumTextStyle.copyWith(
                  color: isStock ? succeedColor : dangerColor,
                  fontSize: pageStyle.unitFontSize * (lang == 'en' ? 14 : 18),
                ),
              ),
            ],
          ),
          Text(
            productEntity.name,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 420,
      child: productEntity.gallery.length < 2
          ? InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                Routes.viewFullImage,
                arguments: productEntity.gallery,
              ),
              child: preCachedImages[0],
            )
          : Swiper(
              itemCount: productEntity.gallery.length,
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
                    arguments: productEntity.gallery,
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
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMore) ...[
            Text(
              productEntity.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
              ),
            )
          ] else if (isLength(productEntity.shortDescription, 110)) ...[
            Text(
              productEntity.shortDescription.substring(0, 110) + ' ...',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
              ),
            )
          ] else ...[
            Text(
              productEntity.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
              ),
            )
          ],
          if (isLength(productEntity.shortDescription, 110)) ...[
            InkWell(
              onTap: () {
                isMore = !isMore;
                setState(() {});
              },
              child: Text(
                isMore ? 'product_less'.tr() : 'product_more'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 14,
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
            'sku'.tr() + ': ' + productEntity.sku,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 12,
              color: primaryColor,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                productEntity.price != null
                    ? productEntity.price
                    : widget?.model?.selectedVariant?.price != null
                        ? widget.model.selectedVariant.price
                        : '',
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 20,
                  color: greyColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: pageStyle.unitWidth * 1),
              if (productEntity.price != null ||
                  widget?.model?.selectedVariant?.price != null) ...[
                Text(
                  'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 12,
                    color: greyColor,
                  ),
                )
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _onFavorite(ProductChangeNotifier model) async {
    if (model.productDetails.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length !=
            model.productDetails.configurable.keys.toList().length) {
      flushBarService.showErrorMessage(pageStyle, 'required_options'.tr());
      return;
    }
    if (model.productDetails.typeId == 'configurable' &&
        (model?.selectedVariant?.stockQty == null ||
            model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorMessage(pageStyle, 'out_of_stock_error'.tr());
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
      await wishlistChangeNotifier.removeItemFromWishlist(
          user.token, widget.product.productId, widget.model.selectedVariant);
    } else {
      await wishlistChangeNotifier.addItemToWishlist(user.token, widget.product,
          1, model.selectedOptions, widget.model.selectedVariant);
    }
  }

  void _onShareProduct() async {
    Uri shareLink =
        await dynamicLinkService.productSharableLink(widget.product);
    Share.share(shareLink.toString(), subject: product.name);
  }
}
