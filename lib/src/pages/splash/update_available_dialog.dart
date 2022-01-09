import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class UpdateAvailableDialog extends StatefulWidget {
  final String title;
  final String content;

  UpdateAvailableDialog({required this.title, required this.content});

  @override
  _UpdateAvailableDialogState createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: boldTextStyle.copyWith(
          fontSize: 20.sp,
          color: darkColor,
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Text(
          widget.content,
          style: mediumTextStyle.copyWith(
            fontSize: 16.sp,
          ),
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text('maybe_later'.tr()),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, 'update'),
          child: Text('update'.tr()),
        ),
      ],
    );
  }
}
