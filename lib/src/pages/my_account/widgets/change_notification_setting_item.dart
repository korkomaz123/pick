import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeNotificationSettingItem extends StatefulWidget {
  final SnackBarService snackBarService;

  ChangeNotificationSettingItem({this.snackBarService});

  @override
  _ChangeNotificationSettingItemState createState() =>
      _ChangeNotificationSettingItemState();
}

class _ChangeNotificationSettingItemState
    extends State<ChangeNotificationSettingItem> {
  SettingBloc settingBloc;
  SnackBarService snackBarService;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    settingBloc = context.read<SettingBloc>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 22.w,
                height: 22.h,
                child: SvgPicture.asset(notificationIcon),
              ),
              SizedBox(width: 10.w),
              Text(
                'account_get_notification_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Consumer<MarkaaAppChangeNotifier>(
            builder: (_, __, ___) {
              return Switch(
                value: isNotification,
                onChanged: (value) => _onChangeNotification(value),
                activeColor: primaryColor,
                inactiveTrackColor: Colors.grey.shade200,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onChangeNotification(bool value) {
    settingBloc.add(NotificationSettingChanged(
      token: user.token,
      isActive: value,
    ));
  }
}
