import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/config.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';

class ToggleLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Config.pageStyle.unitWidth * 120,
      height: Config.pageStyle.unitHeight * 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Config.pageStyle.unitWidth * 8),
        color: Colors.grey.shade300,
      ),
      child: Consumer<GlobalProvider>(
        builder: (context, _globalProvider, child) => SelectOptionCustom(
          items: _globalProvider.languages,
          value: _globalProvider.currentLanguage.toUpperCase(),
          itemWidth: Config.pageStyle.unitWidth * 60,
          itemHeight: Config.pageStyle.unitHeight * 25,
          itemSpace: 0,
          titleSize: Config.pageStyle.unitFontSize * 12,
          radius: 8,
          selectedColor: primaryColor,
          selectedTitleColor: Colors.white,
          selectedBorderColor: Colors.transparent,
          unSelectedColor: Colors.grey.shade300,
          unSelectedTitleColor: greyColor,
          unSelectedBorderColor: Colors.transparent,
          isVertical: false,
          listStyle: true,
          onTap: _globalProvider.changeLanguage,
        ),
      ),
    );
  }
}
