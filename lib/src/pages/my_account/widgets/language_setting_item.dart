import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'restart_mandatory_dialog.dart';

class LanguageSettingItem extends StatefulWidget {
  final PageStyle pageStyle;

  LanguageSettingItem({this.pageStyle});

  @override
  _LanguageSettingItemState createState() => _LanguageSettingItemState();
}

class _LanguageSettingItemState extends State<LanguageSettingItem> {
  PageStyle pageStyle;
  String language;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    language = EasyLocalization.of(context).locale.languageCode.toUpperCase();
    return InkWell(
      onTap: () => null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: pageStyle.unitWidth * 22,
                  height: pageStyle.unitHeight * 22,
                  child: SvgPicture.asset(languageIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'account_language_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ],
            ),
            Container(
              width: pageStyle.unitWidth * 100,
              height: pageStyle.unitHeight * 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: SelectOptionCustom(
                items: ['EN', 'AR'],
                value: language,
                itemWidth: pageStyle.unitWidth * 50,
                itemHeight: pageStyle.unitHeight * 25,
                itemSpace: 0,
                titleSize: pageStyle.unitFontSize * 12,
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
      await showDialog(
        context: context,
        builder: (context) {
          return RestartMandatoryDialog(pageStyle: pageStyle);
        },
      );

      Phoenix.rebirth(context);
    }
  }
}
