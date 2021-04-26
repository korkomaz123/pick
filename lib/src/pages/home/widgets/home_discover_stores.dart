import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeDiscoverStores extends StatefulWidget {
  final PageStyle pageStyle;

  HomeDiscoverStores({this.pageStyle});

  @override
  _HomeDiscoverStoresState createState() => _HomeDiscoverStoresState();
}

class _HomeDiscoverStoresState extends State<HomeDiscoverStores> {
  int activeIndex = 0;
  List<BrandEntity> brands = [];
  BrandChangeNotifier brandChangeNotifier;

  @override
  void initState() {
    super.initState();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 395,
      color: Colors.white,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 15),
      child: Consumer<BrandChangeNotifier>(builder: (_, __, ___) {
        brands = brandChangeNotifier.brandList;
        if (brands.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: widget.pageStyle.unitHeight * 20),
              _buildStoresSlider(),
              Divider(
                height: widget.pageStyle.unitHeight * 4,
                thickness: widget.pageStyle.unitHeight * 1.5,
                color: greyColor.withOpacity(0.4),
              ),
              _buildFooter(),
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }

  Widget _buildTitle() {
    return Text(
      'brands_title'.tr(),
      style: mediumTextStyle.copyWith(
        color: greyDarkColor,
        fontSize: widget.pageStyle.unitFontSize * 26,
      ),
    );
  }

  Widget _buildStoresSlider() {
    int length = brands.length > 20 ? 20 : brands.length;
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.unitHeight * 380,
            child: Swiper(
              itemCount: length,
              autoplay: true,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                activeIndex = value;
                setState(() {});
              },
              itemBuilder: (context, index) {
                BrandEntity brand = brands[index];
                return InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: brands[index],
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: Container(
                    width: widget.pageStyle.deviceWidth,
                    height: widget.pageStyle.unitHeight * 380,
                    padding: EdgeInsets.only(
                      left: widget.pageStyle.unitWidth * 30,
                      right: widget.pageStyle.unitWidth * 30,
                      bottom: widget.pageStyle.unitHeight * 50,
                    ),
                    child: Image.network(
                      brand.brandThumbnail,
                      fit: BoxFit.fill,
                    ),
                  ),
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
                offset: (activeIndex / 2).floor().toDouble(),
                count: (length / 2).ceil(),
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

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 4,
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.brandList,
          arguments: brands,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_more_brands'.tr(),
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
}
