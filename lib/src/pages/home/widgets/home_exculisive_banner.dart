import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_loading_widget.dart';

class HomeExculisiveBanner extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeExculisiveBanner({required this.homeChangeNotifier});

  @override
  _HomeExculisiveBannerState createState() => _HomeExculisiveBannerState();
}

class _HomeExculisiveBannerState extends State<HomeExculisiveBanner> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.exculisiveBanners != null &&
        widget.homeChangeNotifier.exculisiveBanners!.isNotEmpty) {
      return Column(
        children: [
          Container(
            width: designWidth.w,
            height: designWidth.w * (495 / 1466),
            child: Swiper(
              itemCount: widget.homeChangeNotifier.exculisiveBanners!.length,
              autoplay: false,
              autoplayDelay: 5000,
              curve: Curves.easeInOutCubic,
              onIndexChanged: (value) => setState(() => activeIndex = value),
              itemBuilder: (context, index) {
                final banner = widget.homeChangeNotifier.exculisiveBanners![index];
                return InkWell(
                  onTap: () => ActionHandler.onClickBanner(banner, context),
                  child: CachedNetworkImage(
                    key: ValueKey(banner.bannerImage ?? ''),
                    cacheKey: banner.bannerImage ?? '',
                    imageUrl: banner.bannerImage ?? '',
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: widget.homeChangeNotifier.exculisiveBanners!.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 10,
                  dotWidth: 30.w,
                  dotHeight: 3.h,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: greyLightColor,
                  activeDotColor: primarySwatchColor,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return HomeLoadingWidget();
    }
  }
}
