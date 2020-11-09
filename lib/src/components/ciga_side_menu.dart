import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
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
      height: pageStyle.unitHeight * 140,
      color: primaryColor,
      child: Stack(
        children: [
          _buildHeaderLogo(),
          _buildHeaderAuth(),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: pageStyle.unitHeight * 40,
          left: pageStyle.unitWidth * 30,
        ),
        child: user != null
            ? Row(
                children: [
                  Container(
                    width: pageStyle.unitWidth * 57,
                    height: pageStyle.unitWidth * 57,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: user.profileUrl.isNotEmpty
                            ? NetworkImage(user.profileUrl)
                            : AssetImage('lib/public/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: pageStyle.unitWidth * 10),
                  Text(
                    'Hello, ' + user.firstName,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: pageStyle.unitHeight * 5),
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: pageStyle.unitWidth * 95,
                  height: pageStyle.unitHeight * 35,
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderAuth() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => user != null ? _logout() : _login(),
        child: Container(
          padding: EdgeInsets.only(
            left: pageStyle.unitWidth * 30,
            bottom: pageStyle.unitHeight * 10,
          ),
          width: double.infinity,
          child: Row(
            children: [
              SvgPicture.asset(sideLoginIcon),
              SizedBox(width: pageStyle.unitWidth * 4),
              Text(
                user != null ? 'logout'.tr() : 'login'.tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 4,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  bestDealIcon,
                  width: pageStyle.unitWidth * 20,
                  height: pageStyle.unitHeight * 20,
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'side_best_deals'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                    color: greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showMenu = !showMenu;
              activeMenu = categoryMenu;
              setState(() {});
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
              ),
              child: Column(
                children: List.generate(allCategories.length, (index) {
                  return Column(
                    children: [
                      Divider(
                        color: greyColor,
                        thickness: pageStyle.unitHeight * 0.5,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: pageStyle.unitWidth * 10,
                          vertical: pageStyle.unitHeight * 6,
                        ),
                        child: Text(
                          allCategories[index].name,
                          style: TextStyle(
                            color: greyColor,
                            fontSize: pageStyle.unitFontSize * 14,
                          ),
                        ),
                      ),
                      index == (allCategories.length - 1)
                          ? Divider(
                              color: greyColor,
                              thickness: pageStyle.unitHeight * 0.5,
                            )
                          : SizedBox.shrink(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 4,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  shoppingBasketIcon,
                  width: pageStyle.unitWidth * 20,
                  height: pageStyle.unitHeight * 20,
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'brands_title'.tr().toUpperCase(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                    color: greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 4,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  newArrivalIcon,
                  width: pageStyle.unitWidth * 20,
                  height: pageStyle.unitHeight * 20,
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'side_new_arrivals'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                    color: greyDarkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    setState(() {});
  }

  void _logout() {}
}
