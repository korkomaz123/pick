import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:markaa/src/utils/services/action_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_loading_widget.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeHeaderCarousel({required this.homeChangeNotifier});

  @override
  _HomeHeaderCarouselState createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.sliderImages.isEmpty) {
      return HomeLoadingWidget();
    }
    return Container(
      width: double.infinity,
      height: designWidth.w * 579 / 1125,
      color: Colors.white,
      child: Stack(
        children: [_buildImageSlider(), _buildIndicator()],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Swiper(
      itemCount: widget.homeChangeNotifier.sliderImages.length,
      autoplay: true,
      curve: Curves.easeInOutCubic,
      onIndexChanged: (value) => setState(() => activeIndex = value),
      itemBuilder: (context, index) {
        final banner = widget.homeChangeNotifier.sliderImages[index];
        return InkWell(
          onTap: () => ActionHandler.onClickBanner(banner, context),
          child: CachedNetworkImage(
            width: designWidth.w,
            height: designWidth.w * 579 / 1125,
            imageUrl: banner.bannerImage ?? '',
            fit: BoxFit.fill,
            errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            progressIndicatorBuilder: (_, __, ___) {
              return Center(child: PulseLoadingSpinner());
            },
          ),
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 20.w,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: widget.homeChangeNotifier.sliderImages.length,
          axisDirection: Axis.horizontal,
          effect: SlideEffect(
            spacing: 5.w,
            radius: 10,
            dotWidth: 20.w,
            dotHeight: 3.h,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 0,
            dotColor: Colors.white,
            activeDotColor: primarySwatchColor,
          ),
        ),
      ),
    );
  }
}
