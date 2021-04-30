import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeRecent extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeRecent({this.model});

  @override
  _HomeRecentState createState() => _HomeRecentState();
}

class _HomeRecentState extends State<HomeRecent> {
  HomeChangeNotifier model;
  LocalStorageRepository localStorageRepository;
  List<ProductModel> recentlyViews = [];

  @override
  void initState() {
    super.initState();
    localStorageRepository = context.read<LocalStorageRepository>();
    model = widget.model;
    recentlyViews = model.recentlyViewedProducts;
  }

  @override
  Widget build(BuildContext context) {
    if (recentlyViews.isNotEmpty) {
      return Container(
        width: 375.w,
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
                  recentlyViews.length > 20 ? 20 : recentlyViews.length,
                  (index) {
                    return Row(
                      children: [
                        ProductVCard(
                          cardWidth: 175.w,
                          cardHeight: 300.h,
                          product: recentlyViews[index],
                          isShoppingCart: true,
                          isWishlist: true,
                          isShare: true,
                        ),
                        if (index < recentlyViews.length - 1) ...[
                          Container(
                            height: 300.h,
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
