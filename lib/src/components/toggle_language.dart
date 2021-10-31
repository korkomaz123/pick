import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'markaa_select_option.dart';

class ToggleLanguageWidget extends StatefulWidget {
  @override
  State<ToggleLanguageWidget> createState() => _ToggleLanguageWidgetState();
}

class _ToggleLanguageWidgetState extends State<ToggleLanguageWidget> {
  List<dynamic> _languages = <dynamic>['EN', 'عربى'];
  ProgressService? _progressService;

  @override
  void initState() {
    super.initState();
    _progressService = ProgressService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 26.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.grey.shade300,
      ),
      child: MarkaaSelectOption(
        items: _languages,
        value: lang == 'en' ? _languages[0] : _languages[1],
        itemWidth: 60.w,
        itemHeight: 26.h,
        itemSpace: 0,
        titleSize: 12.sp,
        radius: 8,
        selectedColor: primaryColor,
        selectedTitleColor: Colors.white,
        selectedBorderColor: Colors.transparent,
        unSelectedColor: Colors.grey.shade300,
        unSelectedTitleColor: greyColor,
        unSelectedBorderColor: Colors.transparent,
        isVertical: false,
        listStyle: true,
        onTap: (value) async {
          _progressService!.showProgress();

          String val = _languages[0] == value ? 'en' : 'ar';
          Preload.setLanguage(val: val);

          _progressService!.hideProgress();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        },
      ),
    );
  }
}
