import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class NoNetworkAccessPage extends StatefulWidget {
  @override
  _NoNetworkAccessPageState createState() => _NoNetworkAccessPageState();
}

class _NoNetworkAccessPageState extends State<NoNetworkAccessPage> {
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
              width: pageStyle.unitWidth * 245,
              height: pageStyle.unitHeight * 150,
              margin: EdgeInsets.only(
                top: pageStyle.unitHeight * 200,
                bottom: pageStyle.unitHeight * 60,
              ),
              child: SvgPicture.asset(noNetworkIcon),
            ),
            Text(
              'sorry'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 28,
                color: Colors.white60,
              ),
            ),
            Text(
              'no_network_access'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: pageStyle.unitHeight * 42),
            Container(
              width: pageStyle.unitWidth * 166,
              height: pageStyle.unitHeight * 40,
              child: MarkaaTextButton(
                title: 'retry_button_title'.tr(),
                titleSize: pageStyle.unitFontSize * 19,
                titleColor: Colors.white,
                buttonColor: primarySwatchColor,
                borderColor: Colors.white70,
                onPressed: () => _onRetry(),
                radius: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRetry() {
    Phoenix.rebirth(context);
  }
}
