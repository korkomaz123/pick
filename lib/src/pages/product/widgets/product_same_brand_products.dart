import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/product_h_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class ProductSameBrandProducts extends StatefulWidget {
  final ProductModel product;
  final ProductChangeNotifier model;
  ProductSameBrandProducts({this.product, this.model});

  @override
  _ProductSameBrandProductsState createState() =>
      _ProductSameBrandProductsState();
}

class _ProductSameBrandProductsState extends State<ProductSameBrandProducts>
    with TickerProviderStateMixin {
  AnimationController _favoriteController;
  Animation<double> _favoriteScaleAnimation;
  ProductModel product;
  int activeIndex = 0;
  FlushBarService flushBarService;
  ProductChangeNotifier model;
  WishlistChangeNotifier wishlistChangeNotifier;
  @override
  void initState() {
    model = Preload.navigatorKey.currentContext.read<ProductChangeNotifier>();
    wishlistChangeNotifier =
        Preload.navigatorKey.currentContext.read<WishlistChangeNotifier>();
    super.initState();
    flushBarService = FlushBarService(context: context);
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
    product = widget.product;
  }

  DynamicLinkService dynamicLinkService = DynamicLinkService();
  _onShareProduct() async {
    Uri shareLink = await dynamicLinkService
        .productSharableLink(model.sameBrandProducts[activeIndex]);
    Share.share(shareLink.toString(),
        subject: model.sameBrandProducts[activeIndex].name);
  }

  void _onWishlist() async {
    if (widget.product.typeId == 'configurable') {
      Navigator.pushNamed(context, Routes.product,
          arguments: model.sameBrandProducts[activeIndex]);
    } else {
      _favoriteController.repeat(reverse: true);
      Timer.periodic(Duration(milliseconds: 600), (timer) {
        _favoriteController.stop(canceled: true);
        timer.cancel();
      });
      if (isWishlist) {
        wishlistChangeNotifier.removeItemFromWishlist(
            user.token, model.sameBrandProducts[activeIndex]);
      } else {
        wishlistChangeNotifier.addItemToWishlist(
            user.token, model.sameBrandProducts[activeIndex], 1, {});
      }
    }
  }

  bool get isWishlist => _checkFavorite();
  bool _checkFavorite() {
    final variant = model.sameBrandProducts[activeIndex];
    final wishlistItems = wishlistChangeNotifier.wishlistItemsMap;

    bool favorite = false;
    if (model.sameBrandProducts[activeIndex].typeId == 'configurable') {
      favorite = wishlistItems.containsKey(variant?.productId ?? '');
    } else {
      favorite = wishlistItems
          .containsKey(model.sameBrandProducts[activeIndex].productId);
    }
    return favorite;
  }

  @override
  Widget build(BuildContext context) {
    return model.sameBrandProducts != null && model.sameBrandProducts.isNotEmpty
        ? Container(
            width: 375.w,
            color: Colors.white,
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'product_same_brand'.tr(),
                        style: mediumTextStyle.copyWith(fontSize: 16.sp),
                      ),
                    ),
                    InkWell(
                      onTap: () => _onShareProduct(),
                      child: SvgPicture.asset(
                        shareIcon,
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Consumer<WishlistChangeNotifier>(
                      builder: (_, model, __) {
                        return InkWell(
                          onTap: () => user != null
                              ? _onWishlist()
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
                  ],
                ),
                _buildProductCarousel(),
              ],
            ),
          )
        : Container();
  }

  Widget _buildProductCarousel() {
    return Container(
      width: 350.w,
      height: 220.h,
      child: Stack(
        children: [
          Container(
            width: 350.w,
            height: 220.h,
            child: Swiper(
              itemCount: model.sameBrandProducts.length > 10
                  ? 10
                  : model.sameBrandProducts.length,
              autoplay: false,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                activeIndex = value;
                setState(() {});
              },
              itemBuilder: (context, index) {
                return ProductHCard(
                  cardWidth: 343.w,
                  cardHeight: 208.h,
                  product: model.sameBrandProducts[index],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 20.h,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: model.sameBrandProducts.length > 10
                    ? 10
                    : model.sameBrandProducts.length,
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
        ],
      ),
    );
  }
}
