import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/message_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationMessageDetailsPage extends StatefulWidget {
  final MessageEntity message;

  NotificationMessageDetailsPage({required this.message});

  @override
  _NotificationMessageDetailsPageState createState() => _NotificationMessageDetailsPageState();
}

class _NotificationMessageDetailsPageState extends State<NotificationMessageDetailsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      body: Column(
        children: [_buildAppBar(), _buildMessage()],
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: primarySwatchColor, size: 22.sp),
      ),
      centerTitle: true,
      title: Text(
        'account_notification_message_title'.tr(),
        style: mediumTextStyle.copyWith(color: primarySwatchColor, fontSize: 17.sp),
      ),
    );
  }

  Widget _buildMessage() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: 375.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          margin: EdgeInsets.only(bottom: 4.h),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.message.title,
                    style: mediumTextStyle.copyWith(fontSize: 13.sp, color: primaryColor),
                  ),
                  Text(
                    widget.message.time,
                    style: mediumTextStyle.copyWith(fontSize: 9.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                widget.message.content,
                style: mediumTextStyle.copyWith(fontSize: 13.sp, color: greyColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
