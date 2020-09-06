import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductNoAvailable extends StatelessWidget {
  final PageStyle pageStyle;

  ProductNoAvailable({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: pageStyle.unitHeight * 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(greyLogoIcon),
          SizedBox(height: pageStyle.unitHeight * 20),
          Text(
            'no_data_message'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 14,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
