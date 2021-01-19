import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class GetNotificationMessagesItem extends StatefulWidget {
  final PageStyle pageStyle;

  GetNotificationMessagesItem({this.pageStyle});

  @override
  _GetNotificationMessagesItemState createState() => _GetNotificationMessagesItemState();
}

class _GetNotificationMessagesItemState extends State<GetNotificationMessagesItem> {
  PageStyle pageStyle;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.notificationMessages,
      ),
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
                  child: SvgPicture.asset(messageIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'account_notification_message_title'.tr(),
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
}
