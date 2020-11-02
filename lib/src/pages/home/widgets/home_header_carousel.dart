import 'package:ciga/src/data/models/slider_image_entity.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final PageStyle pageStyle;
  final List<SliderImageEntity> sliderImages;

  HomeHeaderCarousel({this.pageStyle, this.sliderImages});

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
          height: widget.pageStyle.unitHeight * 163,
          child: Swiper(
            itemCount: widget.sliderImages.length,
            autoplay: true,
            curve: Curves.easeInOutCubic,
            onIndexChanged: (value) {
              activeIndex = value;
              setState(() {});
            },
            itemBuilder: (context, index) {
              String image = widget.sliderImages[index].bannerImage;
              return Container(
                width: widget.pageStyle.deviceWidth,
                height: widget.pageStyle.unitHeight * 163,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: widget.pageStyle.unitHeight * 140),
            child: SmoothIndicator(
              offset: activeIndex.toDouble(),
              count: widget.sliderImages.length,
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
