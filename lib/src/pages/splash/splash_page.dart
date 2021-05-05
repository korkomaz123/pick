import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalStorageRepository localRepo = LocalStorageRepository();

  @override
  void initState() {
    super.initState();
  }

  void _onLang(String val) async {
    Config.navigatorKey.currentContext.read<GlobalProvider>().changeLanguage(val, fromSplash: true);
    await localRepo.setItem('usage', 'markaa');
    //Start Loading Assets
    await Config.appOpen();
    await Navigator.pushNamedAndRemoveUntil(context, Routes.signIn, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Config.pageStyle = PageStyle(context, designWidth, designHeight);
    Config.pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: Config.pageStyle.deviceWidth,
        height: Config.pageStyle.deviceHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: Config.pageStyle.unitWidth * 260.94,
                height: Config.pageStyle.unitHeight * 180,
                margin: EdgeInsets.only(top: Config.pageStyle.unitHeight * 262.7),
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Config.pageStyle.unitHeight * 141,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Config.pageStyle.unitWidth * 145,
                      height: Config.pageStyle.unitHeight * 49,
                      child: MarkaaTextButton(
                        title: 'English',
                        titleSize: Config.pageStyle.unitFontSize * 20,
                        titleColor: Colors.white,
                        buttonColor: Color(0xFFF7941D),
                        borderColor: Colors.transparent,
                        onPressed: () => _onLang("en"),
                        radius: 30,
                      ),
                    ),
                    SizedBox(width: Config.pageStyle.unitWidth * 13),
                    Container(
                      width: Config.pageStyle.unitWidth * 145,
                      height: Config.pageStyle.unitHeight * 49,
                      child: MarkaaTextButton(
                        title: 'عربى',
                        titleSize: Config.pageStyle.unitFontSize * 20,
                        titleColor: Colors.white,
                        buttonColor: Color(0xFFF7941D),
                        borderColor: Colors.transparent,
                        onPressed: () => _onLang("ar"),
                        radius: 30,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
