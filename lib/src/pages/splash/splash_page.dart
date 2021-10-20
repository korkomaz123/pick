import 'package:markaa/preload.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final localRepository = LocalStorageRepository();
  bool _firstOpen = false;

  @override
  void initState() {
    super.initState();
    _onPrepareAppData();
  }

  Future _onPrepareAppData() async {
    /// LOGIN TO FIREBASE
    Preload.firebaseLogin();

    /// CHECK USER OPEN THE APP FIRST TIME
    _firstOpen = !(await localRepository.existItem('usage'));
    setState(() {});

    /// CHECK THE UPGRADABLE STATUS: MANDATORY OR NOT
    bool isUpgradeRequired = await Preload.checkAppVersion();
    if (!isUpgradeRequired && !_firstOpen) {
      Preload.setLanguage();
      Preload.navigatorKey!.currentState!.pushNamedAndRemoveUntil(
        Routes.home,
        (route) => false,
      );
    }
  }

  void _onLang(String val) async {
    /// Set first time opening passed
    await localRepository.setItem('usage', 'markaa');
    Preload.setLanguage(val: val);

    Preload.navigatorKey!.currentState!.pushNamedAndRemoveUntil(
      Routes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: designWidth.w,
        height: designHeight.h,
        child: Stack(
          children: [
            Positioned(
              top: 262.7.h,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(vLogoIcon, height: 130.h),
              ),
            ),
            if (_firstOpen) ...[
              Positioned(
                bottom: 141.h,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 145.w,
                        height: 49.h,
                        child: MarkaaTextButton(
                          title: 'English',
                          titleSize: 20.sp,
                          titleColor: Colors.white,
                          buttonColor: Color(0xFFF7941D),
                          borderColor: Colors.transparent,
                          onPressed: () => _onLang("en"),
                          radius: 30,
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Container(
                        width: 145.w,
                        height: 49.h,
                        child: MarkaaTextButton(
                          title: 'عربى',
                          titleSize: 20.sp,
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
