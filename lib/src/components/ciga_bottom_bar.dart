import 'package:badges/badges.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';

class CigaBottomBar extends StatelessWidget {
  final PageStyle pageStyle;
  final BottomEnum activeItem;

  CigaBottomBar({this.pageStyle, this.activeItem});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      currentIndex: BottomEnum.values.indexOf(activeItem),
      onTap: (value) => _onChangedTab(value, context),
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(homeIcon),
          ),
          title: Text(
            'bottom_home'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(homeIcon, color: primaryColor),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(categoryIcon),
          ),
          title: Text(
            'bottom_category'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(categoryIcon, color: primaryColor),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(storeIcon),
          ),
          title: Text(
            'brands_title'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(storeIcon, color: primaryColor),
          ),
        ),
        BottomNavigationBarItem(
          icon: BlocBuilder<WishlistItemCountBloc, WishlistItemCountState>(
            builder: (context, state) {
              int count = state.wishlistItemCount;
              return Badge(
                position: BadgePosition.topEnd(
                  top: -pageStyle.unitHeight * 10,
                  end: -pageStyle.unitWidth * 5,
                ),
                badgeColor: orangeColor,
                showBadge: count > 0,
                badgeContent: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: pageStyle.unitFontSize * 8,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  width: pageStyle.unitWidth * 28,
                  height: pageStyle.unitHeight * 26,
                  child: SvgPicture.asset(wishlistIcon),
                ),
              );
            },
          ),
          title: Text(
            'bottom_wishlist'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon:
              BlocBuilder<WishlistItemCountBloc, WishlistItemCountState>(
            builder: (context, state) {
              int count = state.wishlistItemCount;
              return Badge(
                position: BadgePosition.topEnd(
                  top: -pageStyle.unitHeight * 10,
                  end: -pageStyle.unitWidth * 5,
                ),
                badgeColor: orangeColor,
                showBadge: count > 0,
                badgeContent: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: pageStyle.unitFontSize * 8,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  width: pageStyle.unitWidth * 28,
                  height: pageStyle.unitHeight * 26,
                  child: SvgPicture.asset(wishlistIcon, color: primaryColor),
                ),
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(userIcon),
          ),
          title: Text(
            'bottom_account'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(userIcon, color: primaryColor),
          ),
        ),
      ],
    );
  }

  void _onChangedTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
        break;
      case 1:
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   Routes.home,
        //   (route) => false,
        // );
        Navigator.pushNamed(context, Routes.categoryList);
        break;
      case 2:
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   Routes.home,
        //   (route) => false,
        // );
        Navigator.pushNamed(context, Routes.brandList);
        break;
      case 3:
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   Routes.home,
        //   (route) => false,
        // );
        if (user?.token != null) {
          Navigator.pushNamed(context, Routes.wishlist);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
        break;
      case 4:
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   Routes.home,
        //   (route) => false,
        // );
        if (user?.token != null) {
          Navigator.pushNamed(context, Routes.account);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
        break;
      default:
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
        break;
    }
  }
}
