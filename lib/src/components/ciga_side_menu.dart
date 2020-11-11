import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  String activeMenu = '';

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
      height: pageStyle.unitHeight * 160,
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
          left: pageStyle.unitWidth * 20,
        ),
        child: user != null
            ? Row(
                children: [
                  Container(
                    width: pageStyle.unitWidth * 60,
                    height: pageStyle.unitWidth * 60,
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
                      fontSize: pageStyle.unitFontSize * 18,
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
              SvgPicture.asset(
                sideLoginIcon,
                height: pageStyle.unitHeight * 15,
              ),
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
        children: sideMenus.map((menu) {
          return Column(
            children: [
              _buildParentMenu(menu),
              activeMenu == menu.id ? _buildSubmenu(menu) : SizedBox.shrink(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParentMenu(CategoryMenuEntity menu) {
    return InkWell(
      onTap: () =>
          menu.subMenu.isNotEmpty ? _displaySubmenu(menu) : _viewCategory(menu),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: pageStyle.unitHeight * 15),
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 20,
          vertical: pageStyle.unitHeight * 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              menu.title.toUpperCase(),
              style: bookTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: darkColor,
              ),
            ),
            menu.subMenu.isNotEmpty
                ? Icon(
                    activeMenu == menu.id
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right,
                    size: pageStyle.unitFontSize * 25,
                    color: greyDarkColor,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(CategoryMenuEntity menu) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(
          menu.subMenu.length,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 200),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () => _viewCategory(menu.subMenu[index]),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: pageStyle.unitWidth * 40,
                      vertical: pageStyle.unitHeight * 10,
                    ),
                    child: Text(
                      menu.subMenu[index].title,
                      style: bookTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 14,
                        color: darkColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _displaySubmenu(CategoryMenuEntity menu) {
    if (activeMenu == menu.id) {
      activeMenu = '';
    } else {
      activeMenu = menu.id;
    }
    setState(() {});
  }

  void _viewCategory(CategoryMenuEntity menu) {
    ProductListArguments arguments = ProductListArguments(
      category: CategoryEntity(id: menu.id, name: menu.title),
      brand: BrandEntity(),
      subCategory: [],
      selectedSubCategoryIndex: 0,
      isFromBrand: false,
    );
    Navigator.pushNamed(context, Routes.productList, arguments: arguments);
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    setState(() {});
  }

  void _logout() {}
}
