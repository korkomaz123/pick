import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeRecent extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeRecent({@required this.homeChangeNotifier});
  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.recentlyViewedProducts.isNotEmpty) {
      return Container(
        width: designWidth.w,
        height: 370.h,
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.only(bottom: 10.h),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home_recently_view'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 23.sp,
                color: greyDarkColor,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  homeChangeNotifier.recentlyViewedProducts.length > 20
                      ? 20
                      : homeChangeNotifier.recentlyViewedProducts.length,
                  (index) {
                    return Row(
                      children: [
                        ProductVCard(
                          cardWidth: 175.w,
                          cardHeight: 280.h,
                          product:
                              homeChangeNotifier.recentlyViewedProducts[index],
                          isShoppingCart: true,
                          isWishlist: true,
                          isShare: true,
                        ),
                        if (index <
                            homeChangeNotifier.recentlyViewedProducts.length -
                                1) ...[
                          Container(
                            height: 280.h,
                            child: VerticalDivider(
                              width: 1.w,
                              thickness: 1.w,
                              color: greyColor.withOpacity(0.4),
                            ),
                          )
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
