import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistRemoveDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'wishlist_remove_item_dialog_title'.tr(),
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: 26.sp,
          color: Colors.black,
        ),
      ),
      content: Text(
        'wishlist_remove_item_dialog_text'.tr(),
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: 15.sp,
          color: Colors.black87,
        ),
      ),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () => Navigator.pop(context, 'yes'),
          child: Text(
            'yes_button_title'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 18.sp,
              color: primaryColor,
            ),
          ),
        ),
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'no_button_title'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 18.sp,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
