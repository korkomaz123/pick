import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config.dart';

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
    if (widget.homeChangeNotifier.perfumesProducts.isNotEmpty && widget.homeChangeNotifier.perfumesProducts.length > 4) {
      return Column(
        children: [
          _buildProductView(),
          Divider(
            height: Config.pageStyle.unitHeight * 1.5,
            thickness: Config.pageStyle.unitHeight * 1.5,
            color: greyColor.withOpacity(0.4),
          ),
          _buildIndicator(),
          _buildFooter(context),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Config.pageStyle.unitHeight * 4,
        horizontal: Config.pageStyle.unitWidth * 10,
      ),
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: homeCategories[2],
            subCategory: homeCategories[2].subCategories,
            brand: BrandEntity(),
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: arguments,
          );
        },
        title: 'view_all_fragrances'.tr(),
        titleColor: Colors.white,
        titleSize: Config.pageStyle.unitFontSize * 18,
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: Config.pageStyle.unitFontSize * 24,
        ),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 10),
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: widget.homeChangeNotifier.perfumesProducts.length > 40 ? 10 : (widget.homeChangeNotifier.perfumesProducts.length / 4).floor(),
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
        ),
      ),
    );
  }

  Widget _buildProductView() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 590,
      child: Swiper(
        itemCount: widget.homeChangeNotifier.perfumesProducts.length > 40 ? 10 : (widget.homeChangeNotifier.perfumesProducts.length / 4).floor(),
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
                    cardWidth: Config.pageStyle.unitWidth * 179,
                    cardHeight: Config.pageStyle.unitHeight * 290,
                    product: widget.homeChangeNotifier.perfumesProducts[4 * index],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                  Container(
                    width: Config.pageStyle.unitWidth * 179,
                    child: Divider(
                      color: greyColor,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                  ),
                  ProductVCard(
                    cardWidth: Config.pageStyle.unitWidth * 179,
                    cardHeight: Config.pageStyle.unitHeight * 290,
                    product: widget.homeChangeNotifier.perfumesProducts[4 * index + 1],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Config.pageStyle.unitHeight * 2,
                ),
                child: VerticalDivider(
                  width: Config.pageStyle.unitWidth * 1,
                  thickness: Config.pageStyle.unitWidth * 1,
                  color: greyColor.withOpacity(0.4),
                ),
              ),
              Column(
                children: [
                  ProductVCard(
                    cardWidth: Config.pageStyle.unitWidth * 179,
                    cardHeight: Config.pageStyle.unitHeight * 290,
                    product: widget.homeChangeNotifier.perfumesProducts[4 * index + 2],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                  Container(
                    width: Config.pageStyle.unitWidth * 179,
                    child: Divider(
                      color: greyColor,
                      thickness: 0.5,
                      height: 0.5,
                    ),
                  ),
                  ProductVCard(
                    cardWidth: Config.pageStyle.unitWidth * 179,
                    cardHeight: Config.pageStyle.unitHeight * 290,
                    product: widget.homeChangeNotifier.perfumesProducts[4 * index + 3],
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
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
