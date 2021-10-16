import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      child: Center(child: PulseLoadingSpinner()),
    );
  }
}
