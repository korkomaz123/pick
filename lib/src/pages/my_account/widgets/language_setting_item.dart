import 'package:markaa/config.dart';
import 'package:markaa/src/components/toggle_language.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageSettingItem extends StatefulWidget {
  @override
  _LanguageSettingItemState createState() => _LanguageSettingItemState();
}

class _LanguageSettingItemState extends State<LanguageSettingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: Config.pageStyle.unitWidth * 22,
                height: Config.pageStyle.unitHeight * 22,
                child: SvgPicture.asset(languageIcon),
              ),
              SizedBox(width: Config.pageStyle.unitWidth * 10),
              Text(
                'account_language_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: Config.pageStyle.unitFontSize * 16,
                ),
              ),
            ],
          ),
          ToggleLanguageWidget()
        ],
      ),
    );
  }
}
