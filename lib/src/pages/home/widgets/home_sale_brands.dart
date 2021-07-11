import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSaleBrands extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeSaleBrands({this.homeChangeNotifier});

  @override
  _HomeSaleBrandsState createState() => _HomeSaleBrandsState();
}

class _HomeSaleBrandsState extends State<HomeSaleBrands> {
  InfiniteScrollController _controller = InfiniteScrollController();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.saleBrands.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Text(
                'brands_on_sale'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 26.sp,
                  color: darkColor,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 125.w,
              child: InfiniteCarousel.builder(
                itemCount: widget.homeChangeNotifier.saleBrands.length,
                itemExtent: 125.w,
                center: true,
                anchor: 0,
                velocityFactor: 0.2,
                onIndexChanged: (value) {
                  activeIndex = value;
                  setState(() {});
                },
                controller: _controller,
                axisDirection: Axis.horizontal,
                loop: true,
                itemBuilder: (context, itemIndex, realIndex) {
                  return Container(
                    width: 130.w,
                    height: 130.w,
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          elevation: 4,
                          child: Container(
                            width: 110.w,
                            height: 110.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.homeChangeNotifier
                                  .saleBrands[itemIndex].brandThumbnail,
                              width: 110.w,
                              height: 110.w,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: dangerColor,
                              borderRadius: BorderRadius.circular(30.sp),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${widget.homeChangeNotifier.saleBrands[itemIndex].percentage}%',
                                  style: mediumTextStyle.copyWith(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'up_to'.tr(),
                                      style: mediumTextStyle.copyWith(
                                        fontSize: 10.sp,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      'off'.tr(),
                                      style: mediumTextStyle.copyWith(
                                        fontSize: 10.sp,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Center(
                child: SmoothIndicator(
                  offset: (activeIndex / 3).floor().toDouble(),
                  count:
                      (widget.homeChangeNotifier.saleBrands.length / 3).ceil(),
                  axisDirection: Axis.horizontal,
                  effect: SlideEffect(
                    spacing: 8.0,
                    radius: 30,
                    dotWidth: 8.h,
                    dotHeight: 8.h,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 0,
                    dotColor: greyLightColor,
                    activeDotColor: primarySwatchColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }
}
