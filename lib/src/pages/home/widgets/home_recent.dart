import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';

class HomeRecent extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeRecent({@required this.homeChangeNotifier});
  @override
  Widget build(BuildContext context) {
    print("homeChangeNotifier.recentlyViewedProducts ${homeChangeNotifier.recentlyViewedProducts.length}");
    if (homeChangeNotifier.recentlyViewedProducts.isNotEmpty) {
      return Container(
        width: Config.pageStyle.deviceWidth,
        height: Config.pageStyle.unitHeight * 370,
        padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
        margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home_recently_view'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: Config.pageStyle.unitFontSize * 23,
                color: greyDarkColor,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  homeChangeNotifier.recentlyViewedProducts.length > 20 ? 20 : homeChangeNotifier.recentlyViewedProducts.length,
                  (index) {
                    return Row(
                      children: [
                        ProductVCard(
                          cardWidth: Config.pageStyle.unitWidth * 175,
                          cardHeight: Config.pageStyle.unitHeight * 300,
                          product: homeChangeNotifier.recentlyViewedProducts[index],
                          isShoppingCart: true,
                          isWishlist: true,
                          isShare: true,
                        ),
                        if (index < homeChangeNotifier.recentlyViewedProducts.length - 1) ...[
                          Container(
                            height: Config.pageStyle.unitHeight * 300,
                            child: VerticalDivider(
                              width: Config.pageStyle.unitWidth * 1,
                              thickness: Config.pageStyle.unitWidth * 1,
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
