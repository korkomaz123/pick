import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaSideMenu extends StatefulWidget {
  final PageStyle pageStyle;

  CigaSideMenu({this.pageStyle});

  @override
  _CigaSideMenuState createState() => _CigaSideMenuState();
}

class _CigaSideMenuState extends State<CigaSideMenu> {
  PageStyle pageStyle;
  double menuWidth;
  List<CategoryMenuEntity> activeMenu = [];
  bool showMenu = false;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    menuWidth = pageStyle.unitWidth * 300;
    return Container(
      width: menuWidth,
      height: pageStyle.deviceHeight,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildMenuHeader(),
            _buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      width: menuWidth,
      height: pageStyle.unitHeight * 270,
      color: primaryColor,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              logoIcon,
              width: pageStyle.unitWidth * 230,
              height: pageStyle.unitHeight * 130,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                left: pageStyle.unitWidth * 40,
                bottom: pageStyle.unitHeight * 10,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  SvgPicture.asset(sideLoginIcon),
                  SizedBox(width: pageStyle.unitWidth * 4),
                  Text(
                    'Login',
                    style: mediumTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: pageStyle.unitFontSize * 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            leading: SvgPicture.asset(
              bestDealIcon,
              width: pageStyle.unitWidth * 20,
              height: pageStyle.unitHeight * 20,
            ),
            title: Text(
              'BEST DEALS',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: greyColor,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              showMenu = !showMenu;
              activeMenu = categoryMenu;
              setState(() {});
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            leading: SvgPicture.asset(
              sideCategoryIcon,
              width: pageStyle.unitWidth * 20,
              height: pageStyle.unitHeight * 20,
            ),
            title: Text(
              'CATEGORIES',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: greyColor,
              ),
            ),
            trailing: Icon(
              showMenu ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
              size: showMenu
                  ? pageStyle.unitFontSize * 30
                  : pageStyle.unitFontSize * 20,
              color: greyColor,
            ),
          ),
          showMenu ? _buildCategorySubMenu() : SizedBox.shrink(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            leading: SvgPicture.asset(
              shoppingBasketIcon,
              width: pageStyle.unitWidth * 20,
              height: pageStyle.unitHeight * 20,
            ),
            title: Text(
              'STORES',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: greyColor,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            leading: SvgPicture.asset(
              newArrivalIcon,
              width: pageStyle.unitWidth * 20,
              height: pageStyle.unitHeight * 20,
            ),
            title: Text(
              'NEW ARRIVALS',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySubMenu() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.only(left: pageStyle.unitWidth * 80),
      child: Column(
        children: activeMenu.map((menu) {
          return ListTile(
            onTap: () {
              if (menu.subMenu.isNotEmpty) {
                activeMenu = menu.subMenu;
                setState(() {});
              }
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            title: Text(
              menu.title,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: greyColor,
              ),
            ),
            trailing: menu.subMenu.isNotEmpty
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: pageStyle.unitFontSize * 18,
                    color: greyColor,
                  )
                : SizedBox.shrink(),
          );
        }).toList(),
      ),
    );
  }
}
