import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/product_h_card.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeProductsCarousel extends StatefulWidget {
  final PageStyle pageStyle;
  final List<ProductModel> products;
  final bool isVerticalCard;

  HomeProductsCarousel({
    this.pageStyle,
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
            width: widget.pageStyle.deviceWidth,
            height: !widget.isVerticalCard
                ? widget.pageStyle.unitHeight * 200
                : widget.pageStyle.unitHeight * 320,
            child: Swiper(
              itemCount:
                  widget.products.length > 10 ? 10 : widget.products.length,
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
                    cardWidth: widget.pageStyle.unitWidth * 355,
                    cardHeight: widget.pageStyle.unitHeight * 300,
                    product: widget.products[index],
                    pageStyle: widget.pageStyle,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                    isMinor: false,
                  );
                } else {
                  return ProductHCard(
                    cardWidth: widget.pageStyle.unitWidth * 355,
                    cardHeight: widget.pageStyle.unitHeight * 180,
                    product: widget.products[index],
                    pageStyle: widget.pageStyle,
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
                bottom: widget.pageStyle.unitHeight * 20,
              ),
              child: Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return SmoothIndicator(
                    offset: activeIndex.toDouble(),
                    count: widget.products.length > 10
                        ? 10
                        : widget.products.length,
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
