import 'package:markaa/src/components/product_h_card.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductSameBrandProducts extends StatefulWidget {
  final ProductModel product;

  ProductSameBrandProducts({this.product});

  @override
  _ProductSameBrandProductsState createState() => _ProductSameBrandProductsState();
}

class _ProductSameBrandProductsState extends State<ProductSameBrandProducts> {
  ProductModel product;
  int activeIndex = 0;
  List<ProductModel> sameBrandProducts = [];

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _getSameBrandProducts();
  }

  void _getSameBrandProducts() async {
    sameBrandProducts = await ProductRepository().getSameBrandProducts(product.productId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return sameBrandProducts.isNotEmpty
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
                Text(
                  'product_same_brand'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 16.sp,
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
      width: 350.w,
      height: 220.h,
      child: Stack(
        children: [
          Container(
            width: 350.w,
            height: 220.h,
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
                  cardWidth: 343.w,
                  cardHeight: 208.h,
                  product: sameBrandProducts[index],
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
                count: sameBrandProducts.length > 10 ? 10 : sameBrandProducts.length,
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
