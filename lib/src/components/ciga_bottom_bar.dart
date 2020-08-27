import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/strings.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

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
      onTap: (value) {},
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(homeIcon),
          ),
          title: Text(
            homeTitle,
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
            categoryTitle,
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
            storeTitle,
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
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(wishlistIcon),
          ),
          title: Text(
            wishlistTitle,
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 11,
            ),
          ),
          activeIcon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(wishlistIcon, color: primaryColor),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: pageStyle.unitWidth * 28,
            height: pageStyle.unitHeight * 26,
            child: SvgPicture.asset(userIcon),
          ),
          title: Text(
            myAccountTitle,
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
}
