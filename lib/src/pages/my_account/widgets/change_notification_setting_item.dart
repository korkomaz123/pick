import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeNotificationSettingItem extends StatefulWidget {
  @override
  _ChangeNotificationSettingItemState createState() => _ChangeNotificationSettingItemState();
}

class _ChangeNotificationSettingItemState extends State<ChangeNotificationSettingItem> {
  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  SettingRepository settingRepository = SettingRepository();

  @override
  void initState() {
    super.initState();
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
                child: SvgPicture.asset(bellCustomIcon),
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
            builder: (_, model, ___) {
              return Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: isNotification,
                  onChanged: (value) => _onChangeNotification(value, model),
                  activeColor: primaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onChangeNotification(bool value, MarkaaAppChangeNotifier model) {
    settingRepository.changeNotificationSetting(user!.token, value);
    isNotification = value;
    model.rebuild();
  }
}
