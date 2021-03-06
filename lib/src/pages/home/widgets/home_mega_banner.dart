import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../preload.dart';
import 'home_loading_widget.dart';

class HomeMegaBanner extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeMegaBanner({required this.homeChangeNotifier});

  @override
  State<HomeMegaBanner> createState() => _HomeMegaBannerState();
}

class _HomeMegaBannerState extends State<HomeMegaBanner> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.megaBanners.isNotEmpty) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Container(
              width: designWidth.w,
              height: designWidth.w * (864 / 1466),
              child: Swiper(
                viewportFraction: 0.95,
                scale: 0.9,
                itemCount: widget.homeChangeNotifier.megaBanners.length,
                autoplay: false,
                autoplayDelay: 5000,
                curve: Curves.easeInOutCubic,
                onIndexChanged: (value) => setState(() => activeIndex = value),
                itemBuilder: (context, index) {
                  return _buildBannerItem(widget.homeChangeNotifier.megaBanners[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Center(
                child: SmoothIndicator(
                  offset: activeIndex.toDouble(),
                  count: widget.homeChangeNotifier.megaBanners.length,
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
            ),
          ],
        ),
      );
    } else {
      return HomeLoadingWidget();
    }
  }

  Widget _buildBannerItem(SliderImageEntity banner) {
    return InkWell(
      onTap: () async {
        if (banner.categoryId != null) {
          if (banner.categoryId == "1447") {
            Navigator.pushNamed(Preload.navigatorKey!.currentContext!, Routes.summerCollection);
            return;
          }
        }
        ActionHandler.onClickBanner(banner, context);
      },
      child: CachedNetworkImage(
        imageUrl: banner.bannerImage ?? '',
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => Center(
          child: Icon(Icons.image, size: 20),
        ),
      ),
    );
  }
}
