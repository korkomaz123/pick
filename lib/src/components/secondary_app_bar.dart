import 'package:badges/badges.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SecondaryAppBar({Key? key, this.title});

  final String? title;

  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  double? logoWidth;

  double? logoHeight;

  double? pageTitleSize;

  double? pageSubtitleSize;

  double? pageDescSize;

  double? pagePriceSize;

  double? pageTagSize;

  double? pageIconSize;

  double? shoppingCartIconWidth;

  double? shoppingCartIconHeight;

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
      backgroundColor: Colors.white,
      title: widget.title != null
          ? Text(widget.title!, style: mediumTextStyle.copyWith(color: primarySwatchColor, fontSize: 20.sp))
          : Container(
              width: double.infinity,
              height: 30.h,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'search_items'.tr(),
                  hintStyle: TextStyle(color: greyColor),
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
      leading: Navigator.canPop(context)
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, size: 23.sp, color: primarySwatchColor))
          : Container(),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w, left: 20.w),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.myCart),
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
                    position: lang == 'ar' ? BadgePosition.topStart(start: -8.w) : BadgePosition.topEnd(end: -8.w),
                    child: Container(
                      width: 25.w,
                      height: 25.h,
                      child: SvgPicture.asset(shoppingCartIcon, color: primarySwatchColor),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
