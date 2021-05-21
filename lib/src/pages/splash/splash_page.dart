import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../preload.dart';

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
    Preload.navigatorKey.currentContext
        .read<GlobalProvider>()
        .changeLanguage(val, fromSplash: true);
    await localRepo.setItem('usage', 'markaa');
    //Start Loading Assets
    await Preload.appOpen();
    Navigator.pushNamedAndRemoveUntil(
      context,
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 260.94.w,
                height: 180.h,
                margin: EdgeInsets.only(top: 262.7.h),
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 141.h),
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
            )
          ],
        ),
      ),
    );
  }
}
