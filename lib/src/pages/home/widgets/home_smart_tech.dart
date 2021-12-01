import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/amazing_product_card.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/utils/services/action_handler.dart';

import '../../../../preload.dart';
import 'home_loading_widget.dart';

class HomeSmartTech extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeSmartTech({required this.homeChangeNotifier});

  @override
  State<HomeSmartTech> createState() => _HomeSmartTechState();
}

class _HomeSmartTechState extends State<HomeSmartTech> {
  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (widget.homeChangeNotifier.smartTechBanners.isNotEmpty || widget.homeChangeNotifier.smartTechItems.isNotEmpty) {
      return Container(
        width: designWidth.w,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            if (widget.homeChangeNotifier.smartTechBanners.isNotEmpty) ...[
              _buildBanners(widget.homeChangeNotifier.smartTechBanners)
            ],
            SizedBox(height: 10.h),
            if (widget.homeChangeNotifier.smartTechItems.isNotEmpty) ...[
              _buildProducts(
                widget.homeChangeNotifier.smartTechTitle,
                widget.homeChangeNotifier.smartTechCategory!,
                widget.homeChangeNotifier.smartTechItems,
              )
            ],
          ],
        ),
      );
    }
    return HomeLoadingWidget();
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Column(
      children: banners.map((banner) {
        return Container(
          margin: EdgeInsets.only(bottom: 5.h),
          color: Colors.white,
          child: InkWell(
            onTap: () => ActionHandler.onClickBanner(banner, context),
            child: CachedNetworkImage(
              imageUrl: banner.bannerImage ?? '',
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProducts(String title, CategoryEntity category, List<ProductModel> list) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h),
      color: Colors.white,
      width: designWidth.w,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: mediumTextStyle.copyWith(fontSize: 26.sp)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 30.h,
                  child: MarkaaTextButton(
                    title: 'view_all'.tr(),
                    titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
                    titleColor: primaryColor,
                    buttonColor: Colors.white,
                    borderColor: primaryColor,
                    borderWidth: Preload.language == 'en' ? 1 : 0.5,
                    radius: 0,
                    onPressed: () {
                      ProductListArguments arguments = ProductListArguments(
                        category: category,
                        subCategory: [],
                        brand: null,
                        selectedSubCategoryIndex: 0,
                        isFromBrand: false,
                      );
                      Navigator.pushNamed(
                        Preload.navigatorKey!.currentContext!,
                        Routes.productList,
                        arguments: arguments,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 302.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: AmazingProductCard(cardSize: 302.w, contentSize: 100.w, product: list[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
