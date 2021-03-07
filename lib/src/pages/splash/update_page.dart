import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  final String storeLink;

  UpdatePage({this.storeLink});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  PageStyle pageStyle;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.deviceHeight,
        child: Column(
          children: [
            Container(
              width: pageStyle.unitWidth * 294.38,
              height: pageStyle.unitHeight * 150,
              margin: EdgeInsets.only(
                top: pageStyle.unitHeight * 215.9,
                bottom: pageStyle.unitHeight * 38.5,
              ),
              child: SvgPicture.asset(vLogoIcon),
            ),
            Text(
              'sorry'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 28,
                color: Colors.white60,
              ),
            ),
            Text(
              'update_required'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 28,
                color: Colors.white,
              ),
            ),
            SizedBox(height: pageStyle.unitHeight * 42),
            Container(
              width: pageStyle.unitWidth * 166,
              height: pageStyle.unitHeight * 40,
              child: MarkaaTextButton(
                title: 'update_now_button_title'.tr(),
                titleSize: pageStyle.unitFontSize * 19,
                titleColor: Colors.white,
                buttonColor: primarySwatchColor,
                borderColor: Colors.white70,
                onPressed: () => _onUpdate(),
                radius: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate() async {
    if (await canLaunch(widget.storeLink)) {
      await launch(widget.storeLink);
    }
  }
}
