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
      width: 110.w,
      height: 26.h,
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
          itemWidth: 55.w,
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
