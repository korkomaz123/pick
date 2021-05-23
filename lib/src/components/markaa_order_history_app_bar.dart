import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaOrderHistoryAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  _MarkaaOrderHistoryAppBarState createState() =>
      _MarkaaOrderHistoryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _MarkaaOrderHistoryAppBarState extends State<MarkaaOrderHistoryAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 25.sp,
          color: greyColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'my_orders'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: 23.sp,
        ),
      ),
    );
  }
}
