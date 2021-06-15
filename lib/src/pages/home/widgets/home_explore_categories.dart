import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
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
      color: Colors.white,
      child: Consumer<CategoryChangeNotifier>(builder: (_, __, ___) {
        if (widget.homeChangeNotifier.categories.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildCategorySliders(),
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'home_categories'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 26.sp,
            ),
          ),
          Container(
            width: 80.w,
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: 12.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              radius: 0,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.categoryList,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySliders() {
    return Container(
      width: designWidth.w,
      height: 250.h,
      child: Stack(
        children: [
          Container(
            width: designWidth.w,
            height: 250.h,
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
              padding: EdgeInsets.only(bottom: 20.h),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.homeChangeNotifier.categories.length > 10
                    ? 10
                    : widget.homeChangeNotifier.categories.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 0,
                  dotWidth: 20.w,
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
