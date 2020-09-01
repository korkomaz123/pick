import 'package:badges/badges.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey;

  CigaAppBar({this.pageStyle, @required this.scaffoldKey});

  @override
  _CigaAppBarState createState() => _CigaAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(120);
}

class _CigaAppBarState extends State<CigaAppBar> {
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
    logoWidth = widget.pageStyle.unitWidth * 66.17;
    logoHeight = widget.pageStyle.unitHeight * 37.4;
    pageTitleSize = widget.pageStyle.unitFontSize * 23;
    pageSubtitleSize = widget.pageStyle.unitFontSize * 18;
    pageDescSize = widget.pageStyle.unitFontSize * 15;
    pagePriceSize = widget.pageStyle.unitFontSize * 12;
    pageTagSize = widget.pageStyle.unitFontSize * 10;
    pageIconSize = widget.pageStyle.unitFontSize * 25;
    shoppingCartIconWidth = widget.pageStyle.unitWidth * 25.06;
    shoppingCartIconHeight = widget.pageStyle.unitHeight * 23.92;
    return AppBar(
      elevation: 0,
      title: Container(
        width: logoWidth,
        height: logoHeight,
        child: SvgPicture.asset(logoIcon),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white, size: pageIconSize),
        onPressed: () {
          widget.scaffoldKey.currentState.openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: widget.pageStyle.unitWidth * 10),
          child: Center(
            child: Badge(
              badgeColor: badgeColor,
              badgeContent: Text(
                '20',
                style: TextStyle(fontSize: pageTagSize, color: Colors.white),
              ),
              showBadge: true,
              child: Container(
                width: shoppingCartIconWidth,
                height: shoppingCartIconHeight,
                child: SvgPicture.asset(shoppingCartIcon),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(widget.pageStyle.appBarHeight),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.pageStyle.unitWidth * 10,
            // vertical: pageStyle.unitHeight * 4,
          ),
          margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
          child: InputFieldSuffix(
            width: widget.pageStyle.deviceWidth,
            controller: _searchController,
            borderColor: primaryColor,
            radius: 30,
            fontSize: widget.pageStyle.unitFontSize * 13,
            fontColor: greyDarkColor,
            hint: 'search_items'.tr(),
            hintColor: primarySwatchColor,
            hintSize: widget.pageStyle.unitFontSize * 13,
            label: '',
            labelColor: greyDarkColor,
            labelSize: widget.pageStyle.unitFontSize * 13,
            suffixIcon: Icons.search,
            suffixIconSize: pageIconSize,
            suffixIconColor: greyDarkColor,
            readOnly: true,
            onTap: () => Navigator.pushNamed(context, Routes.search),
          ),
        ),
      ),
    );
  }
}
