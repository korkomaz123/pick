import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final PageStyle pageStyle;

  HomeHeaderCarousel({this.pageStyle});

  @override
  _HomeHeaderCarouselState createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.pageStyle.deviceWidth,
          height: widget.pageStyle.unitHeight * 193,
          child: Swiper(
            itemCount: 5,
            autoplay: true,
            curve: Curves.easeInOutCubic,
            onIndexChanged: (value) {
              setState(() {
                activeIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                width: widget.pageStyle.deviceWidth,
                height: widget.pageStyle.unitHeight * 193,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/public/images/Ahlam copy@3x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: widget.pageStyle.unitHeight * 170),
            child: SmoothIndicator(
              offset: activeIndex.toDouble(),
              count: 5,
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
    );
  }
}
