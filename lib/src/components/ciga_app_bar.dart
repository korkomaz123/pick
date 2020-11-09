import 'package:badges/badges.dart';
import 'package:ciga/src/pages/ciga_app/bloc/ciga_app_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isCartPage;

  CigaAppBar({
    this.pageStyle,
    @required this.scaffoldKey,
    this.isCartPage = false,
  });

  @override
  _CigaAppBarState createState() => _CigaAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(110);
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
      centerTitle: true,
      toolbarHeight: widget.pageStyle.unitHeight * 60,
      title: InkWell(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        ),
        child: Container(
          width: logoWidth,
          height: logoHeight,
          child: SvgPicture.asset(logoIcon),
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
            right: widget.pageStyle.unitWidth * 20,
            left: widget.pageStyle.unitWidth * 20,
          ),
          child: InkWell(
            onTap: () => widget.isCartPage
                ? null
                : Navigator.pushNamed(context, Routes.myCart),
            child: Center(
              child: BlocBuilder<CigaAppBloc, CigaAppState>(
                builder: (context, state) {
                  return Badge(
                    badgeColor: badgeColor,
                    badgeContent: Text(
                      '${state.cartItemCount}',
                      style: TextStyle(
                        fontSize: widget.pageStyle.unitFontSize * 8,
                        color: Colors.white,
                      ),
                    ),
                    showBadge: state.cartItemCount > 0,
                    child: Container(
                      width: widget.pageStyle.unitWidth * 25,
                      height: widget.pageStyle.unitHeight * 25,
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
        preferredSize: Size.fromHeight(widget.pageStyle.unitHeight * 40),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.pageStyle.unitWidth * 10,
          ),
          margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 5),
          width: double.infinity,
          height: widget.pageStyle.unitHeight * 40,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'search_items'.tr(),
              hintStyle: TextStyle(color: primarySwatchColor),
              suffixIcon: Icon(
                Icons.search,
                color: greyDarkColor,
                size: widget.pageStyle.unitFontSize * 25,
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
