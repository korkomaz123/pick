import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_custom_vv_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import 'home_loading_widget.dart';

class HomeBestWatches extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeBestWatches({required this.homeChangeNotifier});

  @override
  _HomeBestWatchesState createState() => _HomeBestWatchesState();
}

class _HomeBestWatchesState extends State<HomeBestWatches> {
  int activeIndex = 0;

  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.bestWatchesViewAll != null) {
      return Container(
        width: designWidth.w,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            _buildBanners(widget.homeChangeNotifier.bestWatchesBanners),
            _buildProducts(widget.homeChangeNotifier.bestWatchesItems)
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.homeChangeNotifier.bestWatchesTitle,
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
                  onPressed: () => ActionHandler.onClickBanner(widget.homeChangeNotifier.bestWatchesViewAll!, context),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: banners.map((item) {
              int index = banners.indexOf(item);
              return Row(
                children: [
                  InkWell(
                    onTap: () => ActionHandler.onClickBanner(item, context),
                    child: CachedNetworkImage(
                      key: ValueKey(item.bannerImage ?? ''),
                      cacheKey: item.bannerImage ?? '',
                      width: banners.length == 1 ? 375.w : 340.w,
                      height: (banners.length == 1 ? 375.w : 340.w) * (897 / 1096),
                      imageUrl: item.bannerImage ?? '',
                      fit: BoxFit.fitHeight,
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                    ),
                  ),
                  if (index < banners.length - 1) ...[SizedBox(width: 5.w)],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      height: 330.h,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: 5.w),
          child: ProductCustomVVCard(
            cardWidth: 170.w,
            cardHeight: 310.h,
            product: list[index],
            isShoppingCart: true,
            isLine: false,
            isMinor: true,
            isWishlist: true,
            isShare: false,
            borderRadius: 10.sp,
            onAddToCartFailure: () => widget.homeChangeNotifier.updateBestWatchesProduct(index),
          ),
        ),
      ),
    );
  }
}
