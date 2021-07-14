import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeDiscoverStores extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeDiscoverStores({@required this.homeChangeNotifier});

  @override
  _HomeDiscoverStoresState createState() => _HomeDiscoverStoresState();
}

class _HomeDiscoverStoresState extends State<HomeDiscoverStores> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.brandList.isNotEmpty) {
      return Container(
        height: 280.h,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildStoresSlider(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              'brands_title'.tr(),
              maxLines: 1,
              style: mediumTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: 26.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              borderWidth: Preload.language == 'en' ? 1 : 0.5,
              radius: 0,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.brandList,
                  arguments: widget.homeChangeNotifier.brandList,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresSlider() {
    int length = widget.homeChangeNotifier.brandList.length > 20
        ? 20
        : widget.homeChangeNotifier.brandList.length;
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: designWidth.w,
            height: 200.h,
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
                BrandEntity brand = widget.homeChangeNotifier.brandList[index];
                return InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: widget.homeChangeNotifier.brandList[index],
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: brand.brandThumbnail,
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.image, size: 20)),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: SmoothIndicator(
                offset: (activeIndex / 2).floor().toDouble(),
                count: (length / 2).ceil(),
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
