import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 20.h),
          _buildStoresSlider(),
          Divider(
            height: 4.h,
            thickness: 1.5.h,
            color: greyColor.withOpacity(0.4),
          ),
          _buildFooter(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildTitle() {
    return Text(
      'brands_title'.tr(),
      style: mediumTextStyle.copyWith(
        color: greyDarkColor,
        fontSize: 26.sp,
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
            width: 375.w,
            height: 380.h,
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
                  child: Container(
                    width: 375.w,
                    height: 380.h,
                    padding: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                      bottom: 50.h,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: brand.brandThumbnail,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.image, size: 20)),
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
                bottom: 20.h,
              ),
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

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.brandList,
          arguments: widget.homeChangeNotifier.brandList,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_more_brands'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 15.sp,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
