import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import 'home_loading_widget.dart';

class HomeNewArrivalsBanner extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeNewArrivalsBanner({required this.homeChangeNotifier});

  @override
  _HomeNewArrivalsBannerState createState() => _HomeNewArrivalsBannerState();
}

class _HomeNewArrivalsBannerState extends State<HomeNewArrivalsBanner> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.sunglassesViewAll != null) {
      final banner = widget.homeChangeNotifier.sunglassesViewAll;
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.homeChangeNotifier.sunglassesTitle,
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(fontSize: Preload.language == 'en' ? 26 : 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    height: 30.h,
                    child: MarkaaTextButton(
                      title: 'view_all'.tr(),
                      titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
                      titleColor: primaryColor,
                      buttonColor: Colors.white,
                      borderColor: primaryColor,
                      borderWidth: Preload.language == 'en' ? 1 : 0.5,
                      radius: 0,
                      onPressed: () => ActionHandler.onClickBanner(banner!, context),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.homeChangeNotifier.sunglassesBanners.map((item) {
                  int index = widget.homeChangeNotifier.sunglassesBanners.indexOf(item);
                  bool single = widget.homeChangeNotifier.sunglassesBanners.length == 1;
                  return Row(
                    children: [
                      InkWell(
                        onTap: () => ActionHandler.onClickBanner(item, context),
                        child: CachedNetworkImage(
                          width: single ? 375.w : 340.w,
                          height: (single ? 375.w : 340.w) * (897 / 1096),
                          imageUrl: item.bannerImage ?? '',
                          fit: BoxFit.fitHeight,
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                        ),
                      ),
                      if (index < widget.homeChangeNotifier.sunglassesBanners.length - 1) ...[SizedBox(width: 5.w)],
                    ],
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 175.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.homeChangeNotifier.sunglassesItems.length,
                itemBuilder: (context, index) => ProductCard(
                  cardWidth: 120.w,
                  cardHeight: 175.w,
                  product: widget.homeChangeNotifier.sunglassesItems[index],
                  isWishlist: true,
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
}
