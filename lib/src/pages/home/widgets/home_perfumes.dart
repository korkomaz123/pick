import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePerfumes extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomePerfumes({@required this.homeChangeNotifier});

  @override
  _HomePerfumesState createState() => _HomePerfumesState();
}

class _HomePerfumesState extends State<HomePerfumes> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.perfumesProducts.isNotEmpty &&
        widget.homeChangeNotifier.perfumesProducts.length > 4) {
      return Consumer<HomeChangeNotifier>(builder: (_, __, ___) {
        return Container(
          width: designWidth.w,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 10.h),
          child: Column(
            children: [
              _buildProductView(),
              Divider(
                height: 0.5.h,
                thickness: 0.5.h,
                color: greyColor.withOpacity(0.4),
              ),
              _buildIndicator(),
            ],
          ),
        );
      });
    } else {
      return Container();
    }
  }

  Widget _buildIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: widget.homeChangeNotifier.perfumesProducts.length > 40
              ? 10
              : (widget.homeChangeNotifier.perfumesProducts.length / 4).floor(),
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
    );
  }

  Widget _buildProductView() {
    return Container(
      width: designWidth.w,
      height: 581.h,
      child: Swiper(
        itemCount: widget.homeChangeNotifier.perfumesProducts.length > 40
            ? 10
            : (widget.homeChangeNotifier.perfumesProducts.length / 4).floor(),
        autoplay: false,
        curve: Curves.easeIn,
        duration: 300,
        autoplayDelay: 5000,
        onIndexChanged: (value) {
          activeIndex = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ProductVCard(
                    cardWidth: 179.w,
                    cardHeight: 290.h,
                    product:
                        widget.homeChangeNotifier.perfumesProducts[4 * index],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    onAddToCartFailure: () => widget.homeChangeNotifier
                        .updatePerfumesProduct(4 * index),
                  ),
                  Container(
                    width: 179.w,
                    child: Divider(
                      color: greyColor,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                  ),
                  ProductVCard(
                    cardWidth: 179.w,
                    cardHeight: 290.h,
                    product: widget
                        .homeChangeNotifier.perfumesProducts[4 * index + 1],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    onAddToCartFailure: () => widget.homeChangeNotifier
                        .updatePerfumesProduct(4 * index + 1),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: VerticalDivider(
                  width: 1.w,
                  thickness: 1.w,
                  color: greyColor.withOpacity(0.4),
                ),
              ),
              Column(
                children: [
                  ProductVCard(
                    cardWidth: 179.w,
                    cardHeight: 290.h,
                    product: widget
                        .homeChangeNotifier.perfumesProducts[4 * index + 2],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    onAddToCartFailure: () => widget.homeChangeNotifier
                        .updatePerfumesProduct(4 * index + 2),
                  ),
                  Container(
                    width: 179.w,
                    child: Divider(
                      color: greyColor,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                  ),
                  ProductVCard(
                    cardWidth: 179.w,
                    cardHeight: 290.h,
                    product: widget
                        .homeChangeNotifier.perfumesProducts[4 * index + 3],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    onAddToCartFailure: () => widget.homeChangeNotifier
                        .updatePerfumesProduct(4 * index + 3),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
