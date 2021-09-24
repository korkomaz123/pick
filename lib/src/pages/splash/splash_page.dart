import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalStorageRepository localRepo = LocalStorageRepository();

  bool isNew = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      isNew = !(await localRepo.existItem('usage'));
      setState(() {});
    });

    Future.delayed(Duration(milliseconds: 1000), () async {
      if (await Preload.checkAppVersion() != true) if (!isNew)
        Preload.navigatorKey.currentState.pushNamedAndRemoveUntil(
          Routes.home,
          (route) => false,
        );
    });
  }

  void _onLang(String val) async {
    /// Set the language on the backend side
    Preload.navigatorKey.currentContext
        .read<GlobalProvider>()
        .changeLanguage(val, fromSplash: true);

    /// Set language on onesignal
    OneSignal.shared.addTrigger('lang', val);

    /// Set first time opening passed
    await localRepo.setItem('usage', 'markaa');

    /// Start Loading Assets
    await Preload.appOpen();
    Preload.navigatorKey.currentState.pushNamedAndRemoveUntil(
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
            if (isNew) ...[
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
