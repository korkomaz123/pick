import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class RateAppItem extends StatefulWidget {
  final PageStyle pageStyle;

  RateAppItem({this.pageStyle});

  @override
  _RateAppItemState createState() => _RateAppItemState();
}

class _RateAppItemState extends State<RateAppItem> {
  final InAppReview inAppReview = InAppReview.instance;
  PageStyle pageStyle;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onRateApp(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: pageStyle.unitWidth * 22,
                  height: pageStyle.unitHeight * 22,
                  child: SvgPicture.asset(rateIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'account_rate_app_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onRateApp() async {
    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // }
    inAppReview.openStoreListing(
      appStoreId: '1549591755',
      microsoftStoreId: '',
    );
  }
}
