import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  final String storeLink;

  UpdatePage({required this.storeLink});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: primarySwatchColor,
        body: Container(
          width: 375.w,
          height: 812.h,
          child: Column(
            children: [
              Container(
                width: 294.38.w,
                height: 150.h,
                margin: EdgeInsets.only(
                  top: 215.9.h,
                  bottom: 38.5.h,
                ),
                child: SvgPicture.asset(vLogoIcon),
              ),
              Text(
                'sorry'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 28.sp,
                  color: Colors.white60,
                ),
              ),
              Text(
                'update_required'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 28.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 42.h),
              Container(
                width: 166.w,
                height: 40.h,
                child: MarkaaTextButton(
                  title: 'update_now_button_title'.tr(),
                  titleSize: 19.sp,
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
      ),
    );
  }

  void _onUpdate() async {
    if (await canLaunch(widget.storeLink)) {
      await launch(widget.storeLink);
    }
  }
}
