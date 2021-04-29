import 'package:badges/badges.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaBottomBar extends StatelessWidget {
  final BottomEnum activeItem;

  MarkaaBottomBar({this.activeItem});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      currentIndex: BottomEnum.values.indexOf(activeItem),
      onTap: (value) => _onChangedTab(value, context),
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(homeIcon),
          ),
          // ignore: deprecated_member_use
          title: Text(
            'bottom_home'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 11.sp,
            ),
          ),
          activeIcon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(homeActiveIcon),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(categoryIcon),
          ),
          // ignore: deprecated_member_use
          title: Text(
            'bottom_category'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 11.sp,
            ),
          ),
          activeIcon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(categoryActiveIcon),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(storeIcon),
          ),
          // ignore: deprecated_member_use
          title: Text(
            'brands_title'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 11.sp,
            ),
          ),
          activeIcon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(storeActiveIcon),
          ),
        ),
        BottomNavigationBarItem(
          icon: Consumer<WishlistChangeNotifier>(
            builder: (_, model, __) {
              int count = model.wishlistItemsCount;
              return Badge(
                position: BadgePosition.topEnd(top: -10.h, end: -5.w),
                badgeColor: orangeColor,
                showBadge: count > 0,
                badgeContent: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  width: 28.w,
                  height: 26.h,
                  child: SvgPicture.asset(wishlistIcon),
                ),
              );
            },
          ),
          // ignore: deprecated_member_use
          title: Text(
            'bottom_wishlist'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 11.sp,
            ),
          ),
          activeIcon: Consumer<WishlistChangeNotifier>(
            builder: (_, model, __) {
              int count = model.wishlistItemsCount;
              return Badge(
                position: BadgePosition.topEnd(top: -10.h, end: -5.w),
                badgeColor: orangeColor,
                showBadge: count > 0,
                toAnimate: false,
                animationDuration: Duration.zero,
                badgeContent: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  width: 28.w,
                  height: 26.h,
                  child: SvgPicture.asset(wishlistActiveIcon),
                ),
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(userIcon),
          ),
          // ignore: deprecated_member_use
          title: Text(
            'bottom_account'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 11.sp,
            ),
          ),
          activeIcon: Container(
            width: 28.w,
            height: 26.h,
            child: SvgPicture.asset(userActiveIcon),
          ),
        ),
      ],
    );
  }

  void _onChangedTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.categoryList,
          (route) => route.settings.name == Routes.home,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.brandList,
          (route) => route.settings.name == Routes.home,
        );
        break;
      case 3:
        if (user?.token != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.wishlist,
            (route) => route.settings.name == Routes.home,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => route.settings.name == Routes.home,
          );
        }
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.account,
          (route) => route.settings.name == Routes.home,
        );
        break;
      default:
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
        break;
    }
  }
}
