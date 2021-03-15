import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePerfumes extends StatefulWidget {
  final PageStyle pageStyle;

  HomePerfumes({this.pageStyle});

  @override
  _HomePerfumesState createState() => _HomePerfumesState();
}

class _HomePerfumesState extends State<HomePerfumes> {
  CategoryEntity perfumes = homeCategories[2];
  List<ProductModel> perfumesProducts;
  String title;
  HomeChangeNotifier homeChangeNotifier;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    homeChangeNotifier.loadPerfumes(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Consumer<HomeChangeNotifier>(
        builder: (_, model, __) {
          perfumesProducts = model.perfumesProducts;
          title = model.perfumesTitle;
          if (perfumesProducts.isNotEmpty && perfumesProducts.length > 4) {
            return Column(
              children: [
                _buildHeadline(),
                Divider(
                  height: widget.pageStyle.unitHeight * 4,
                  thickness: widget.pageStyle.unitHeight * 1.5,
                  color: greyColor.withOpacity(0.4),
                ),
                _buildProductView(),
                Divider(
                  height: widget.pageStyle.unitHeight * 4,
                  thickness: widget.pageStyle.unitHeight * 1.5,
                  color: greyColor.withOpacity(0.4),
                ),
                _buildIndicator(),
                _buildFooter(context),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: mediumTextStyle.copyWith(
              fontSize: widget.pageStyle.unitFontSize * 26,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitHeight * 4),
      child: InkWell(
        onTap: () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_all'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 15,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: widget.pageStyle.unitFontSize * 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitHeight * 10),
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: perfumesProducts.length > 40
              ? 10
              : (perfumesProducts.length / 4).floor(),
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
    );
  }

  Widget _buildProductView() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 600,
      child: Swiper(
        itemCount: perfumesProducts.length > 40
            ? 10
            : (perfumesProducts.length / 4).floor(),
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
                    cardWidth: widget.pageStyle.unitWidth * 179,
                    cardHeight: widget.pageStyle.unitHeight * 290,
                    product: perfumesProducts[4 * index],
                    pageStyle: widget.pageStyle,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                  Container(
                    width: widget.pageStyle.unitWidth * 179,
                    child: Divider(color: greyColor, thickness: 0.5),
                  ),
                  ProductVCard(
                    cardWidth: widget.pageStyle.unitWidth * 179,
                    cardHeight: widget.pageStyle.unitHeight * 290,
                    product: perfumesProducts[4 * index + 1],
                    pageStyle: widget.pageStyle,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: widget.pageStyle.unitHeight * 2,
                ),
                child: VerticalDivider(
                  width: widget.pageStyle.unitWidth * 1,
                  thickness: widget.pageStyle.unitWidth * 1,
                  color: greyColor.withOpacity(0.4),
                ),
              ),
              Column(
                children: [
                  ProductVCard(
                    cardWidth: widget.pageStyle.unitWidth * 179,
                    cardHeight: widget.pageStyle.unitHeight * 290,
                    product: perfumesProducts[4 * index + 2],
                    pageStyle: widget.pageStyle,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                  Container(
                    width: widget.pageStyle.unitWidth * 179,
                    child: Divider(color: greyColor, thickness: 0.5),
                  ),
                  ProductVCard(
                    cardWidth: widget.pageStyle.unitWidth * 179,
                    cardHeight: widget.pageStyle.unitHeight * 290,
                    product: perfumesProducts[4 * index + 3],
                    pageStyle: widget.pageStyle,
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
