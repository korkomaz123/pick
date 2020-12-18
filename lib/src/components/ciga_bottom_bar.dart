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
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(homeIcon),
          ),
          title: Text(
            'bottom_home'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(homeActiveIcon),
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
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(categoryActiveIcon),
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
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(storeActiveIcon),
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
            style: mediumTextStyle.copyWith(
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
                  child: SvgPicture.asset(wishlistActiveIcon),
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
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
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
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
        Navigator.pushNamed(context, Routes.categoryList);
        break;
      case 2:
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
        Navigator.pushNamed(context, Routes.brandList);
        break;
      case 3:
        if (user?.token != null) {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == Routes.home,
          );
          Navigator.pushNamed(context, Routes.wishlist);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
        break;
      case 4:
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
        Navigator.pushNamed(context, Routes.account);
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
