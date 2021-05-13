import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_category_card.dart';

class HomeExploreCategories extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeExploreCategories({@required this.homeChangeNotifier});

  @override
  _HomeExploreCategoriesState createState() => _HomeExploreCategoriesState();
}

class _HomeExploreCategoriesState extends State<HomeExploreCategories> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: designWidth.w,
      height: 340.h,
      color: Colors.white,
      child: Consumer<CategoryChangeNotifier>(builder: (_, __, ___) {
        if (widget.homeChangeNotifier.categories.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildCategorySliders(),
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
    return Container(
      width: designWidth.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      child: Text(
        'home_categories'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: 26.sp,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: designWidth.w,
      height: 40.h,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.categoryList,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_more_categories'.tr(),
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

  Widget _buildCategorySliders() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: designWidth.w,
            height: 250.h,
            color: Colors.white,
            child: Swiper(
              itemCount: widget.homeChangeNotifier.categories.length > 10
                  ? 10
                  : widget.homeChangeNotifier.categories.length,
              autoplay: false,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                activeIndex = value;
                setState(() {});
              },
              itemBuilder: (context, index) {
                return HomeCategoryCard(
                  category: widget.homeChangeNotifier.categories[index],
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
                count: widget.homeChangeNotifier.categories.length > 10
                    ? 10
                    : widget.homeChangeNotifier.categories.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 0,
                  dotWidth: 24.0,
                  dotHeight: 2.h,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: Colors.white,
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
