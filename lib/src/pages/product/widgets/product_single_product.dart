import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductSingleProduct extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductEntity product;

  ProductSingleProduct({this.pageStyle, this.product});

  @override
  _ProductSingleProductState createState() => _ProductSingleProductState();
}

class _ProductSingleProductState extends State<ProductSingleProduct> {
  PageStyle pageStyle;
  ProductEntity product;
  bool isMore = false;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;
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
        children: [
          InkWell(
            child: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(closeIcon),
            ),
          ),
          InkWell(
            child: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(wishlistedIcon),
            ),
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
                return Image.asset(
                  'lib/public/images/shutterstock_151558448-1.png',
                  width: pageStyle.unitWidth * 343,
                  height: pageStyle.unitHeight * 240.31,
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
                'product_store'.tr(),
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

  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: pageStyle.unitWidth * 271,
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
            height: pageStyle.unitHeight * 49,
            color: greyLightColor,
            child: Container(
              width: pageStyle.unitWidth * 25,
              height: pageStyle.unitHeight * 25,
              child: SvgPicture.asset(shoppingCartIcon, color: primaryColor),
            ),
            onTap: () => null,
            radius: 1,
          ),
        ],
      ),
    );
  }
}
