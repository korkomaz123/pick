import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationMessagesPage extends StatefulWidget {
  @override
  _NotificationMessagesPageState createState() => _NotificationMessagesPageState();
}

class _NotificationMessagesPageState extends State<NotificationMessagesPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: SecondaryAppBar(title: 'account_notification_message_title'.tr()),
      body: _buildMessageList(),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            messages.length,
            (index) {
              return InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.notificationMessageDetails,
                  arguments: messages[index],
                ),
                child: Container(
                  width: 375.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  margin: EdgeInsets.only(bottom: 4.h),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: 300.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index].time,
                              style: mediumTextStyle.copyWith(fontSize: 9.sp),
                            ),
                            Text(
                              messages[index].title,
                              style: mediumTextStyle.copyWith(fontSize: 13.sp, color: primaryColor),
                            ),
                            Text(
                              messages[index].content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: mediumTextStyle.copyWith(fontSize: 13.sp, color: greyColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.arrow_forward_ios, color: primaryColor, size: 22.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
