import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'markaa_select_option.dart';

class ToggleLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 25.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.grey.shade300,
      ),
      child: Consumer<GlobalProvider>(
        builder: (context, _globalProvider, child) => MarkaaSelectOption(
          items: _globalProvider.languages,
          value: _globalProvider.currentLanguage.toUpperCase(),
          itemWidth: 60.w,
          itemHeight: 25.h,
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
          onTap: (value) {
            _globalProvider.changeLanguage(value);
            Phoenix.rebirth(context);
          },
        ),
      ),
    );
  }
}
