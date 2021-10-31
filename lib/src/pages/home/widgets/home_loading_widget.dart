import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';

class HomeLoadingWidget extends StatefulWidget {
  const HomeLoadingWidget({Key? key}) : super(key: key);

  @override
  State<HomeLoadingWidget> createState() => _HomeLoadingWidgetState();
}

class _HomeLoadingWidgetState extends State<HomeLoadingWidget> {
  bool _expired = false;
  late Timer _loadingTimer;

  @override
  void initState() {
    super.initState();
    _loadingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _expired = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_loadingTimer.isActive) _loadingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_expired) {
      return Container();
    }
    return Container(
      height: 260.h,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      child: Center(child: PulseLoadingSpinner()),
    );
  }
}
