import 'package:ciga/src/components/product_h_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductSameBrandProducts extends StatefulWidget {
  final PageStyle pageStyle;

  ProductSameBrandProducts({this.pageStyle});

  @override
  _ProductSameBrandProductsState createState() =>
      _ProductSameBrandProductsState();
}

class _ProductSameBrandProductsState extends State<ProductSameBrandProducts> {
  PageStyle pageStyle;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product_same_brand'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
          _buildProductCarousel(),
        ],
      ),
    );
  }

  Widget _buildProductCarousel() {
    return Container(
      width: widget.pageStyle.unitWidth * 350,
      height: widget.pageStyle.unitHeight * 220,
      child: Stack(
        children: [
          Container(
            width: widget.pageStyle.unitWidth * 350,
            height: widget.pageStyle.unitHeight * 220,
            child: Swiper(
              itemCount: products.length,
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
                return ProductHCard(
                  cardWidth: widget.pageStyle.unitWidth * 343,
                  cardHeight: widget.pageStyle.unitHeight * 208,
                  product: products[index],
                  pageStyle: widget.pageStyle,
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
                count: products.length,
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
