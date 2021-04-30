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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeDiscoverStores extends StatefulWidget {
  final BrandChangeNotifier model;

  HomeDiscoverStores({@required this.model});
  @override
  _HomeDiscoverStoresState createState() => _HomeDiscoverStoresState();
}

class _HomeDiscoverStoresState extends State<HomeDiscoverStores> {
  int activeIndex = 0;
  List<BrandEntity> brands = [];
  BrandChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    brands = model.brandList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 395.h,
      color: Colors.white,
      padding: EdgeInsets.all(15.w),
      child: Column(
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
      ),
    );
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
    int length = brands.length > 20 ? 20 : brands.length;
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
                    width: 375.w,
                    height: 380.h,
                    padding: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                      bottom: 50.h,
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
          arguments: brands,
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
