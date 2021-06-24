import 'package:badges/badges.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaSimpleAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isCartPage;
  final bool isCenter;

  MarkaaSimpleAppBar({
    @required this.scaffoldKey,
    this.isCartPage = false,
    this.isCenter = true,
  });

  @override
  _MarkaaSimpleAppBarState createState() => _MarkaaSimpleAppBarState();
}

class _MarkaaSimpleAppBarState extends State<MarkaaSimpleAppBar> {
  double logoWidth;

  double logoHeight;

  double pageTitleSize;

  double pageSubtitleSize;

  double pageDescSize;

  double pagePriceSize;

  double pageTagSize;

  double pageIconSize;

  double shoppingCartIconWidth;

  double shoppingCartIconHeight;

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    logoWidth = 66.17.w;
    logoHeight = 37.4.h;
    pageTitleSize = 23.sp;
    pageSubtitleSize = 18.sp;
    pageDescSize = 15.sp;
    pagePriceSize = 12.sp;
    pageTagSize = 10.sp;
    pageIconSize = 25.sp;
    shoppingCartIconWidth = 25.06.w;
    shoppingCartIconHeight = 23.92.h;
    return Consumer<MarkaaAppChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          color: primarySwatchColor,
          child: Column(
            children: [
              Container(
                width: designWidth.w,
                height: 90.h,
                padding: EdgeInsets.only(top: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: pageIconSize,
                      ),
                      onPressed: () {
                        widget.scaffoldKey.currentState.openDrawer();
                      },
                    ),
                    InkWell(
                      onTap: () => Navigator.popUntil(
                        context,
                        (route) => route.settings.name == Routes.home,
                      ),
                      child: Container(
                        width: 160.w,
                        child: SvgPicture.asset(hLogoIcon),
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.isCartPage
                          ? null
                          : Navigator.pushNamed(context, Routes.myCart),
                      icon: Center(
                        child: Consumer<MyCartChangeNotifier>(
                          builder: (_, model, __) {
                            return Badge(
                              badgeColor: badgeColor,
                              badgeContent: Text(
                                '${model.cartTotalCount}',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                ),
                              ),
                              showBadge: model.cartItemCount > 0,
                              toAnimate: false,
                              animationDuration: Duration.zero,
                              position: lang == 'ar'
                                  ? BadgePosition.topStart(start: -8.w)
                                  : BadgePosition.topEnd(end: -8.w),
                              child: Container(
                                width: 25.w,
                                height: 25.h,
                                child: SvgPicture.asset(shoppingCartIcon),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: designWidth.w,
                height: model.isShowingSearchBar ? 40.h : 0,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.sp),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.sp),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.sp),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'search_items'.tr(),
                    hintStyle: TextStyle(color: primarySwatchColor),
                    suffixIcon: Icon(
                      Icons.search,
                      color: greyDarkColor,
                      size: 25.sp,
                    ),
                  ),
                  readOnly: true,
                  onTap: () => Navigator.pushNamed(context, Routes.search),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
