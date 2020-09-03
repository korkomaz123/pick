import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaOrderHistoryAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final PageStyle pageStyle;

  CigaOrderHistoryAppBar({this.pageStyle});

  @override
  _CigaOrderHistoryAppBarState createState() => _CigaOrderHistoryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _CigaOrderHistoryAppBarState extends State<CigaOrderHistoryAppBar> {
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
        'my_orders'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: pageStyle.unitFontSize * 23,
        ),
      ),
    );
  }
}
