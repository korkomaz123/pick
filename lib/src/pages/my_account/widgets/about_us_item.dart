import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class AboutUsItem extends StatelessWidget {
  final PageStyle pageStyle;

  AboutUsItem({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.aboutUs),
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
                  child: SvgPicture.asset(aboutUsIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'account_about_us_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }
}
