import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import 'home_loading_widget.dart';

class HomeBestDealsBanner extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeBestDealsBanner({required this.homeChangeNotifier});

  @override
  _HomeBestDealsBannerState createState() => _HomeBestDealsBannerState();
}

class _HomeBestDealsBannerState extends State<HomeBestDealsBanner> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.faceCareViewAll != null) {
      return Container(
        width: designWidth.w,
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
                      widget.homeChangeNotifier.faceCareTitle,
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
                      onPressed: () => ActionHandler.onClickBanner(widget.homeChangeNotifier.faceCareViewAll!, context),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.homeChangeNotifier.faceCareBanners.map((item) {
                  List<SliderImageEntity> faceCareBanners = [];
                  faceCareBanners = widget.homeChangeNotifier.faceCareBanners;
                  int index = faceCareBanners.indexOf(item);
                  return Row(
                    children: [
                      InkWell(
                        onTap: () => ActionHandler.onClickBanner(item, context),
                        child: item.bannerImageFile != null
                            ? Image.file(
                                item.bannerImageFile!,
                                width: faceCareBanners.length == 1 ? 375.w : 340.w,
                                height: (faceCareBanners.length == 1 ? 375.w : 340.w) * (897 / 1096),
                                fit: BoxFit.fitHeight,
                              )
                            : CachedNetworkImage(
                                width: faceCareBanners.length == 1 ? 375.w : 340.w,
                                height: (faceCareBanners.length == 1 ? 375.w : 340.w) * (897 / 1096),
                                imageUrl: item.bannerImage ?? '',
                                fit: BoxFit.fitHeight,
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                              ),
                      ),
                      if (index < faceCareBanners.length - 1) ...[SizedBox(width: 5.w)],
                    ],
                  );
                }).toList(),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  widget.homeChangeNotifier.faceCareProducts.length,
                  (index) {
                    return ProductCard(
                      cardWidth: 120.w,
                      cardHeight: 175.w,
                      product: widget.homeChangeNotifier.faceCareProducts[index],
                      isWishlist: true,
                    );
                  },
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
