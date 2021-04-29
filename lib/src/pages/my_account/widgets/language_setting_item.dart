import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:markaa/src/components/markaa_select_option.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/config/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/progress_service.dart';

class LanguageSettingItem extends StatefulWidget {
  @override
  _LanguageSettingItemState createState() => _LanguageSettingItemState();
}

class _LanguageSettingItemState extends State<LanguageSettingItem> {
  ProgressService progressService;
  String language;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  SettingRepository settingRepository;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    settingRepository = context.read<SettingRepository>();
  }

  @override
  Widget build(BuildContext context) {
    language = EasyLocalization.of(context).locale.languageCode.toUpperCase();
    return InkWell(
      onTap: () => null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.h,
                  child: SvgPicture.asset(languageIcon),
                ),
                SizedBox(width: 10.w),
                Text(
                  'account_language_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Container(
              width: 120.w,
              height: 25.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: MarkaaSelectOption(
                items: ['EN', 'AR'],
                value: language,
                itemWidth: 60.w,
                itemHeight: 25.h,
                itemSpace: 0,
                titleSize: 12.sp,
                radius: 8,
                selectedColor: primaryColor,
                selectedTitleColor: Colors.white,
                selectedBorderColor: Colors.transparent,
                unSelectedColor: Colors.grey.shade300,
                unSelectedTitleColor: greyColor,
                unSelectedBorderColor: Colors.transparent,
                isVertical: false,
                listStyle: true,
                onTap: (value) => _onChangeLanguage(value),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onChangeLanguage(String value) async {
    if (language != value) {
      progressService.showProgress();
      language = value;
      if (language == 'EN') {
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales.first;
        lang = 'en';
      } else {
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales.last;
        lang = 'ar';
      }
      String topic = lang == 'en'
          ? MarkaaNotificationChannels.arChannel
          : MarkaaNotificationChannels.enChannel;
      await firebaseMessaging.unsubscribeFromTopic(topic);
      firebaseMessaging.getToken().then((String token) async {
        deviceToken = token;
        if (user?.token != null) {
          await settingRepository.updateFcmDeviceToken(
            user.token,
            Platform.isAndroid ? token : '',
            Platform.isIOS ? token : '',
            Platform.isAndroid ? lang : '',
            Platform.isIOS ? lang : '',
          );
        }
        progressService.hideProgress();
        Phoenix.rebirth(context);
      });
    }
  }
}
