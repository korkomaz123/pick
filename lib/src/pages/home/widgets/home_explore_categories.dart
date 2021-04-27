import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config.dart';
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
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 340,
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
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 15,
      ),
      child: Text(
        'home_categories'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: Config.pageStyle.unitFontSize * 26,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 40,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 15,
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
                fontSize: Config.pageStyle.unitFontSize * 15,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: Config.pageStyle.unitFontSize * 15,
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
            width: Config.pageStyle.deviceWidth,
            height: Config.pageStyle.unitHeight * 250,
            color: Colors.white,
            child: Swiper(
              itemCount: widget.homeChangeNotifier.categories.length > 10 ? 10 : widget.homeChangeNotifier.categories.length,
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
                bottom: Config.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.homeChangeNotifier.categories.length > 10 ? 10 : widget.homeChangeNotifier.categories.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 0,
                  dotWidth: 24.0,
                  dotHeight: Config.pageStyle.unitHeight * 2,
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
