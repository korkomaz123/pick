import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaCheckoutAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PageStyle pageStyle;

  CigaCheckoutAppBar({this.pageStyle});

  @override
  _CigaCheckoutAppBarState createState() => _CigaCheckoutAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(120);
}

class _CigaCheckoutAppBarState extends State<CigaCheckoutAppBar> {
  PageStyle pageStyle;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: pageStyle.unitFontSize * 25,
          color: greyColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Checkout',
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: pageStyle.unitFontSize * 23,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: pageStyle.unitWidth * 8),
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: pageStyle.unitFontSize * 25,
              color: greyColor,
            ),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            ),
          ),
        ),
      ],
    );
  }
}
