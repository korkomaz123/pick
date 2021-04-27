import 'package:markaa/src/components/product_h_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductSameBrandProducts extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductModel product;

  ProductSameBrandProducts({this.pageStyle, this.product});

  @override
  _ProductSameBrandProductsState createState() => _ProductSameBrandProductsState();
}

class _ProductSameBrandProductsState extends State<ProductSameBrandProducts> {
  PageStyle pageStyle;
  ProductModel product;
  int activeIndex = 0;
  List<ProductModel> sameBrandProducts = [];

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;
    _getSameBrandProducts();
  }

  void _getSameBrandProducts() async {
    sameBrandProducts = await ProductRepository().getSameBrandProducts(product.productId, lang);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return sameBrandProducts.isNotEmpty
        ? Container(
            width: pageStyle.deviceWidth,
            color: Colors.white,
            margin: EdgeInsets.only(top: pageStyle.unitHeight * 10),
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
          )
        : Container();
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
              itemCount: sameBrandProducts.length > 10 ? 10 : sameBrandProducts.length,
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
                  cardWidth: widget.pageStyle.unitWidth * 343,
                  cardHeight: widget.pageStyle.unitHeight * 208,
                  product: sameBrandProducts[index],
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
                count: sameBrandProducts.length > 10 ? 10 : sameBrandProducts.length,
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
