import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import 'home_loading_widget.dart';

class HomeAdvertise extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeAdvertise({required this.homeChangeNotifier});

  @override
  _HomeAdvertiseState createState() => _HomeAdvertiseState();
}

class _HomeAdvertiseState extends State<HomeAdvertise> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.skinCareViewAll != null) {
      SliderImageEntity banner = widget.homeChangeNotifier.skinCareViewAll!;
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.homeChangeNotifier.skinCareTitle,
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(fontSize: 26.sp),
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
                      onPressed: () => ActionHandler.onClickBanner(banner, context),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.homeChangeNotifier.skinCareBanners.map((item) {
                  int index = widget.homeChangeNotifier.skinCareBanners.indexOf(item);
                  bool single = widget.homeChangeNotifier.skinCareBanners.length == 1;
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
                          progressIndicatorBuilder: (_, __, ___) {
                            return Center(child: PulseLoadingSpinner());
                          },
                        ),
                      ),
                      if (index < widget.homeChangeNotifier.skinCareBanners.length - 1) ...[SizedBox(width: 5.w)],
                    ],
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 175.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.homeChangeNotifier.skinCareItems.length,
                itemBuilder: (context, index) => ProductCard(
                  cardWidth: 120.w,
                  cardHeight: 175.w,
                  product: widget.homeChangeNotifier.skinCareItems[index],
                  isWishlist: true,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }
}
