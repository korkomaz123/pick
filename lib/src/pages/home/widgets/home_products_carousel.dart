import 'package:ciga/src/components/product_h_card.dart';
import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeProductsCarousel extends StatefulWidget {
  final PageStyle pageStyle;
  final List<ProductModel> products;
  final int crossAxisCount;
  final bool isVerticalCard;

  HomeProductsCarousel({
    this.pageStyle,
    this.products,
    this.crossAxisCount = 1,
    this.isVerticalCard = true,
  });

  @override
  _HomeProductsCarouselState createState() => _HomeProductsCarouselState();
}

class _HomeProductsCarouselState extends State<HomeProductsCarousel> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: widget.pageStyle.deviceWidth,
            height: !widget.isVerticalCard
                ? widget.pageStyle.unitHeight * 320
                : widget.pageStyle.unitHeight * 460,
            child: Swiper(
              itemCount:
                  (widget.products.length / widget.crossAxisCount).ceil(),
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
                return widget.crossAxisCount == 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isVerticalCard
                              ? ProductVCard(
                                  cardWidth: widget.pageStyle.unitWidth * 155,
                                  cardHeight: widget.pageStyle.unitHeight * 360,
                                  product: widget.products[index],
                                  pageStyle: widget.pageStyle,
                                  isShoppingCart: true,
                                  isWishlist: true,
                                  isShare: true,
                                )
                              : ProductHCard(
                                  cardWidth: widget.pageStyle.unitWidth * 155,
                                  cardHeight: widget.pageStyle.unitHeight * 360,
                                  product: widget.products[index],
                                  pageStyle: widget.pageStyle,
                                  isShoppingCart: true,
                                  isWishlist: true,
                                  isShare: true,
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: widget.pageStyle.unitHeight * 2,
                              bottom: widget.pageStyle.unitHeight * 100,
                            ),
                            child: VerticalDivider(
                              width: widget.pageStyle.unitWidth * 4,
                              thickness: widget.pageStyle.unitWidth * 1,
                              color: greyColor.withOpacity(0.4),
                            ),
                          ),
                          widget.isVerticalCard
                              ? ProductVCard(
                                  cardWidth: widget.pageStyle.unitWidth * 155,
                                  cardHeight: widget.pageStyle.unitHeight * 360,
                                  product: widget.products[index],
                                  pageStyle: widget.pageStyle,
                                  isShoppingCart: true,
                                  isWishlist: true,
                                  isShare: true,
                                )
                              : ProductHCard(
                                  cardWidth: widget.pageStyle.unitWidth * 155,
                                  cardHeight: widget.pageStyle.unitHeight * 360,
                                  product: widget.products[index],
                                  pageStyle: widget.pageStyle,
                                  isShoppingCart: true,
                                  isWishlist: true,
                                  isShare: true,
                                ),
                        ],
                      )
                    : widget.isVerticalCard
                        ? ProductVCard(
                            cardWidth: widget.pageStyle.unitWidth * 355,
                            cardHeight: widget.pageStyle.unitHeight * 360,
                            product: widget.products[index],
                            pageStyle: widget.pageStyle,
                            isShoppingCart: true,
                            isWishlist: true,
                            isShare: true,
                          )
                        : ProductHCard(
                            cardWidth: widget.pageStyle.unitWidth * 355,
                            cardHeight: widget.pageStyle.unitHeight * 220,
                            product: widget.products[index],
                            pageStyle: widget.pageStyle,
                            isShoppingCart: true,
                            isWishlist: true,
                            isShare: true,
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
                count: (widget.products.length / widget.crossAxisCount).ceil(),
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
}
