import 'dart:async';

import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductSingleProduct extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductEntity product;

  ProductSingleProduct({this.pageStyle, this.product});

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct> with TickerProviderStateMixin {
  PageStyle pageStyle;
  ProductEntity product;
  bool isMore = false;
  int activeIndex = 0;
  bool isFavorite = true;
  AnimationController _addToCartController;
  AnimationController _favoriteController;
  Animation<double> _addToCartScaleAnimation;
  Animation<double> _favoriteScaleAnimation;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;

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
      parent: _addToCartController,
      curve: Curves.easeIn,
    ));

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
    _addToCartController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      color: Colors.white,
      padding: EdgeInsets.all(pageStyle.unitWidth * 8),
      child: Column(
        children: [
          _buildTitlebar(),
          _buildImageCarousel(),
          _buildTitle(),
          _buildDescription(),
          _buildPrice(),
          SizedBox(height: pageStyle.unitHeight * 10),
          _buildToolbar(),
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
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(closeIcon),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () => _onShareProduct(),
                child: Icon(Icons.share, color: greyDarkColor),
              ),
              SizedBox(height: pageStyle.unitHeight * 10),
              InkWell(
                onTap: () {
                  _onFavorite();
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: ScaleTransition(
                  scale: _favoriteScaleAnimation,
                  child: Container(
                    width: pageStyle.unitWidth * 22,
                    height: pageStyle.unitHeight * 22,
                    child: SvgPicture.asset(
                      !isFavorite ? wishlistedIcon : wishlistIcon,
                    ),
                  ),
                ),
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
      height: widget.pageStyle.unitHeight * 300,
      child: Stack(
        children: [
          Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.unitHeight * 300,
            child: Swiper(
              itemCount: 3,
              autoplay: true,
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
                    arguments: {'pageStyle': pageStyle},
                  ),
                  child: Image.asset(
                    'lib/public/images/shutterstock_151558448-1.png',
                    width: pageStyle.unitWidth * 343,
                    height: pageStyle.unitHeight * 240.31,
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: widget.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: 3,
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
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'product_channel'.tr(),
                style: boldTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 20,
                ),
              ),
              SizedBox(width: pageStyle.unitWidth * 10),
              Text(
                'In stock',
                style: mediumTextStyle.copyWith(
                  color: succeedColor,
                  fontSize: pageStyle.unitFontSize * 11,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'product_brand'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 11,
                ),
              ),
              Text(
                product.store.name,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      child: Wrap(
        children: [
          isMore
              ? Text(
                  product.description,
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                )
              : Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
          InkWell(
            onTap: () {
              setState(() {
                isMore = !isMore;
              });
            },
            child: Text(
              isMore ? 'product_less'.tr() : 'product_more'.tr(),
              style: bookTextStyle.copyWith(
                color: primaryColor,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          )
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
          Row(
            children: [
              Text(
                product.price.toString() + ' ' + 'currency'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 14,
                  color: greyColor,
                ),
              ),
              SizedBox(width: pageStyle.unitWidth * 10),
              Text(
                product.discount.toString() + ' ' + 'currency'.tr(),
                style: mediumTextStyle.copyWith(
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: dangerColor,
                  fontSize: pageStyle.unitFontSize * 14,
                  color: greyColor,
                ),
              ),
            ],
          ),
          Text(
            'suk'.tr() + ' ' + '2018',
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 10,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: pageStyle.unitWidth * 296,
            height: pageStyle.unitHeight * 50,
            child: TextButton(
              title: 'product_buy_now'.tr(),
              titleSize: pageStyle.unitFontSize * 23,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              radius: 1,
              onPressed: () => Navigator.pushNamed(context, Routes.myCart),
            ),
          ),
          RoundImageButton(
            width: pageStyle.unitWidth * 58,
            height: pageStyle.unitHeight * 50,
            color: greyLightColor,
            child: ScaleTransition(
              scale: _addToCartScaleAnimation,
              child: Container(
                width: pageStyle.unitWidth * 25,
                height: pageStyle.unitHeight * 25,
                child: SvgPicture.asset(shoppingCartIcon, color: primaryColor),
              ),
            ),
            onTap: () => _onAddToCart(product),
            radius: 1,
          ),
        ],
      ),
    );
  }

  void _onAddToCart(ProductEntity product) {
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
    _showSnackbar();
  }

  void _onFavorite() {
    _favoriteController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _favoriteController.stop(canceled: true);
      timer.cancel();
    });
  }

  void _showSnackbar() {
    Flushbar(
      messageText: Container(
        width: pageStyle.unitWidth * 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 15,
                  ),
                ),
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cart Total',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
                Text(
                  'KD 460',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: pageStyle.unitWidth * 20,
        height: pageStyle.unitHeight * 20,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[100],
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: primaryColor,
    )..show(context);
  }

  void _onShareProduct() {
    Share.share('Share my product');
  }
}
