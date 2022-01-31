import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import 'home_loading_widget.dart';
import 'home_perfumes.dart';

class HomeFragrancesBanners extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeFragrancesBanners({required this.homeChangeNotifier});

  @override
  State<HomeFragrancesBanners> createState() => _HomeFragrancesBannersState();
}

class _HomeFragrancesBannersState extends State<HomeFragrancesBanners> {
  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.fragrancesBanners.isNotEmpty ||
        widget.homeChangeNotifier.fragrancesBannersTitle.isNotEmpty) {
      return Container(
        width: designWidth.w,
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10.h),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            if (widget.homeChangeNotifier.fragrancesBannersTitle.isNotEmpty) ...[
              _buildTitle(widget.homeChangeNotifier.fragrancesBannersTitle, context)
            ],
            if (widget.homeChangeNotifier.fragrancesBanners.isNotEmpty) ...[
              _buildBanners(widget.homeChangeNotifier.fragrancesBanners, context)
            ],
            HomePerfumes(homeChangeNotifier: widget.homeChangeNotifier),
            _buildViewAllButton(),
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }

  Widget _buildTitle(String title, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Text(
        title,
        maxLines: 1,
        style: mediumTextStyle.copyWith(fontSize: 26.sp),
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: banners.map((banner) {
          int index = banners.indexOf(banner);
          return Padding(
            padding: EdgeInsets.only(bottom: index < banners.length - 1 ? 3.h : 0),
            child: InkWell(
              onTap: () => ActionHandler.onClickBanner(banner, context),
              child: CachedNetworkImage(
                imageUrl: banner.bannerImage ?? '',
                errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Container(
      width: 375.w,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MarkaaTextButton(
        title: 'view_all'.tr(),
        titleSize: 20.sp,
        titleColor: Colors.white,
        buttonColor: primarySwatchColor,
        borderColor: Colors.transparent,
        onPressed: () async {
          ProductListArguments arguments = ProductListArguments(
            category: homeCategories[2],
            subCategory: homeCategories[2].subCategories,
            brand: null,
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(context, Routes.productList, arguments: arguments);
        },
      ),
    );
  }
}
