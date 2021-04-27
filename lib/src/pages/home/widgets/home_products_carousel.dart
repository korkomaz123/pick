import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/product_h_card.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config.dart';

class HomeProductsCarousel extends StatefulWidget {
  final List<ProductModel> products;
  final bool isVerticalCard;

  HomeProductsCarousel({
    this.products,
    this.isVerticalCard = true,
  });

  @override
  _HomeProductsCarouselState createState() => _HomeProductsCarouselState();
}

class _HomeProductsCarouselState extends State<HomeProductsCarousel> {
  int activeIndex = 0;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;

  @override
  void initState() {
    super.initState();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: Config.pageStyle.deviceWidth,
            height: !widget.isVerticalCard ? Config.pageStyle.unitHeight * 200 : Config.pageStyle.unitHeight * 320,
            child: Swiper(
              itemCount: widget.products.length,
              autoplay: false,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                activeIndex = value;
                markaaAppChangeNotifier.rebuild();
              },
              itemBuilder: (context, index) {
                if (widget.isVerticalCard) {
                  return ProductVCard(
                    cardWidth: Config.pageStyle.unitWidth * 355,
                    cardHeight: Config.pageStyle.unitHeight * 300,
                    product: widget.products[index],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    isMinor: false,
                  );
                } else {
                  return ProductHCard(
                    cardWidth: Config.pageStyle.unitWidth * 355,
                    cardHeight: Config.pageStyle.unitHeight * 180,
                    product: widget.products[index],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    isMinor: false,
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Config.pageStyle.unitHeight * 20,
              ),
              child: Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return SmoothIndicator(
                    offset: (activeIndex / 2).floor().toDouble(),
                    count: (widget.products.length / 2).ceil(),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
