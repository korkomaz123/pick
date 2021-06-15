import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'markaa_select_option.dart';

class ToggleLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 30.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.grey.shade300,
      ),
      child: Consumer<GlobalProvider>(
        builder: (context, _globalProvider, child) => MarkaaSelectOption(
          items: _globalProvider.languages,
          value: _globalProvider.currentLanguage == 'en'
              ? _globalProvider.languages[0]
              : _globalProvider.languages[1],
          itemWidth: 50.w,
          itemHeight: 30.h,
          itemSpace: 0,
          titleSize: 14.sp,
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
            _globalProvider.changeLanguage(
                _globalProvider.languages[0] == value ? 'en' : 'ar');

            await Preload.appOpen();

            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
