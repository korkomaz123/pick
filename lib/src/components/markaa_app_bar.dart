import 'package:badges/badges.dart';
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

class MarkaaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isCartPage;
  final bool isCenter;

  MarkaaAppBar({
    @required this.scaffoldKey,
    this.isCartPage = false,
    this.isCenter = true,
  });

  @override
  _MarkaaAppBarState createState() => _MarkaaAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _MarkaaAppBarState extends State<MarkaaAppBar> {
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
    return AppBar(
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 60.h,
      title: InkWell(
        onTap: () => Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        ),
        child: Container(
          width: 160.w,
          child: SvgPicture.asset(hLogoIcon),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white, size: pageIconSize),
        onPressed: () {
          widget.scaffoldKey.currentState.openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: 20.w,
            left: 20.w,
          ),
          child: InkWell(
            onTap: () => widget.isCartPage
                ? null
                : Navigator.pushNamed(context, Routes.myCart),
            child: Center(
              child: Consumer<MyCartChangeNotifier>(
                builder: (_, model, __) {
                  return Badge(
                    badgeColor: badgeColor,
                    badgeContent: Text(
                      '${model.cartTotalCount}',
                      style: TextStyle(fontSize: 8.sp, color: Colors.white),
                    ),
                    showBadge: model.cartItemCount > 0,
                    toAnimate: false,
                    animationDuration: Duration.zero,
                    position: lang == 'ar'
                        ? BadgePosition.topStart(
                            start: -8.w,
                          )
                        : BadgePosition.topEnd(
                            end: -8.w,
                          ),
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
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          margin: EdgeInsets.only(
            bottom: (widget.isCenter ? 15.h : 10.h),
          ),
          width: double.infinity,
          height: 40.h,
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
      ),
    );
  }
}
