import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config.dart';

class ProductNoAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            hLogoIcon,
            color: greyColor.withOpacity(0.5),
            width: Config.pageStyle.unitWidth * 80,
            height: Config.pageStyle.unitHeight * 20,
          ),
          SizedBox(height: Config.pageStyle.unitHeight * 20),
          Text(
            'no_data_message'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 14,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
