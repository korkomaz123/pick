import 'package:ciga/src/components/ciga_page_loading_kit.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
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
  _ChangeNotificationSettingItemState createState() =>
      _ChangeNotificationSettingItemState();
}

class _ChangeNotificationSettingItemState
    extends State<ChangeNotificationSettingItem> {
  PageStyle pageStyle;
  SettingBloc settingBloc;
  SnackBarService snackBarService;
  bool getNotification;

  @override
  void initState() {
    super.initState();
    getNotification = true;
    pageStyle = widget.pageStyle;
    settingBloc = context.bloc<SettingBloc>();
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
