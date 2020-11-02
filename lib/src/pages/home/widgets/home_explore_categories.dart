import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/pages/home/widgets/home_category_card.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeExploreCategories extends StatefulWidget {
  final PageStyle pageStyle;
  final List<CategoryEntity> categories;

  HomeExploreCategories({this.pageStyle, this.categories});

  @override
  _HomeExploreCategoriesState createState() => _HomeExploreCategoriesState();
}

class _HomeExploreCategoriesState extends State<HomeExploreCategories> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 380,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitWidth * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.pageStyle.unitWidth * 15,
            ),
            child: Text(
              'home_categories'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: widget.pageStyle.unitFontSize * 23,
              ),
            ),
          ),
          SizedBox(height: widget.pageStyle.unitHeight * 20),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: widget.pageStyle.deviceWidth,
                  height: widget.pageStyle.unitHeight * 460,
                  child: Swiper(
                    itemCount: widget.categories.length > 8
                        ? 8
                        : widget.categories.length,
                    autoplay: true,
                    curve: Curves.easeIn,
                    duration: 300,
                    autoplayDelay: 5000,
                    onIndexChanged: (value) {
                      activeIndex = value;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return HomeCategoryCard(
                        pageStyle: widget.pageStyle,
                        category: widget.categories[index],
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
                      count: widget.categories.length > 8
                          ? 8
                          : widget.categories.length,
                      axisDirection: Axis.horizontal,
                      effect: SlideEffect(
                        spacing: 8.0,
                        radius: 0,
                        dotWidth: 24.0,
                        dotHeight: widget.pageStyle.unitHeight * 2,
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
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: widget.pageStyle.unitHeight * 4,
              horizontal: widget.pageStyle.unitWidth * 15,
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.categoryList),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'view_more_categories'.tr(),
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
          ),
        ],
      ),
    );
  }
}
