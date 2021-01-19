import 'package:markaa/src/components/ciga_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_repository.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ChangeNotificationSettingItem extends StatefulWidget {
  final PageStyle pageStyle;
  final SnackBarService snackBarService;

  ChangeNotificationSettingItem({this.pageStyle, this.snackBarService});

  @override
  _ChangeNotificationSettingItemState createState() => _ChangeNotificationSettingItemState();
}

class _ChangeNotificationSettingItemState extends State<ChangeNotificationSettingItem> {
  PageStyle pageStyle;
  SettingBloc settingBloc;
  SnackBarService snackBarService;
  bool getNotification;

  @override
  void initState() {
    super.initState();
    getNotification = true;
    pageStyle = widget.pageStyle;
    settingBloc = context.read<SettingBloc>();
    _getNotification();
  }

  void _getNotification() async {
    getNotification = await context.read<SettingRepository>().getNotificationSetting(user.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: pageStyle.unitWidth * 22,
                  height: pageStyle.unitHeight * 22,
                  child: SvgPicture.asset(notificationIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'account_get_notification_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ],
            ),
            BlocConsumer<SettingBloc, SettingState>(
              listener: (context, state) {
                if (state is NotificationSettingChangedFailure) {
                  snackBarService.showErrorSnackBar(state.message);
                }
              },
              builder: (context, state) {
                if (state is NotificationSettingChangedInProcess) {
                  return CircleLoadingSpinner();
                }
                if (state is NotificationSettingChangedSuccess) {
                  getNotification = state.status;
                }
                return Switch(
                  value: getNotification,
                  onChanged: (value) => _onChangeNotification(value),
                  activeColor: primaryColor,
                  inactiveTrackColor: Colors.grey.shade200,
                );
              },
            ),
          ],
        ),
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
