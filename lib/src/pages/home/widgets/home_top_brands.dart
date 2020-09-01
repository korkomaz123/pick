import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeTopBrands extends StatefulWidget {
  final PageStyle pageStyle;

  HomeTopBrands({this.pageStyle});

  @override
  _HomeTopBrandsState createState() => _HomeTopBrandsState();
}

class _HomeTopBrandsState extends State<HomeTopBrands> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 395,
      color: Colors.white,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home_top_brands'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: widget.pageStyle.unitFontSize * 23,
            ),
          ),
          SizedBox(height: widget.pageStyle.unitHeight * 20),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: widget.pageStyle.deviceWidth,
                  height: widget.pageStyle.unitHeight * 174,
                  child: Swiper(
                    itemCount: 8,
                    autoplay: true,
                    curve: Curves.easeIn,
                    duration: 300,
                    autoplayDelay: 5000,
                    onIndexChanged: (value) {
                      setState(() {
                        activeIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        width: widget.pageStyle.deviceWidth * 253,
                        height: widget.pageStyle.unitHeight * 174,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'lib/public/images/Image 44@3x.png',
                            ),
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
                      offset: activeIndex.toDouble(),
                      count: 8,
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
          ),
          Divider(
            height: widget.pageStyle.unitHeight * 4,
            thickness: widget.pageStyle.unitHeight * 1.5,
            color: greyColor.withOpacity(0.4),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: widget.pageStyle.unitHeight * 4,
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.brandList),
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
          ),
        ],
      ),
    );
  }
}
