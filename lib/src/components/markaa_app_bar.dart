import 'package:badges/badges.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MarkaaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isCartPage;
  final bool isCenter;

  MarkaaAppBar({
    this.pageStyle,
    @required this.scaffoldKey,
    this.isCartPage = false,
    this.isCenter = true,
  });

  @override
  _MarkaaAppBarState createState() => _MarkaaAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _MarkaaAppBarState extends State<MarkaaAppBar> {
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
        onTap: () => Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        ),
        child: Container(
          width: widget.pageStyle.unitWidth * 160,
          child: SvgPicture.asset(hLogoIcon),
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
              child: Consumer<MyCartChangeNotifier>(
                builder: (_, model, __) {
                  return Badge(
                    badgeColor: badgeColor,
                    badgeContent: Text(
                      '${model.cartTotalCount}',
                      style: TextStyle(
                        fontSize: widget.pageStyle.unitFontSize * 8,
                        color: Colors.white,
                      ),
                    ),
                    showBadge: model.cartItemCount > 0,
                    toAnimate: false,
                    animationDuration: Duration.zero,
                    position: lang == 'ar'
                        ? BadgePosition.topStart(
                            start: -widget.pageStyle.unitWidth * 8,
                          )
                        : BadgePosition.topEnd(
                            end: -widget.pageStyle.unitWidth * 8,
                          ),
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
          margin: EdgeInsets.only(
            bottom: widget.pageStyle.unitHeight * (widget.isCenter ? 15 : 10),
          ),
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
