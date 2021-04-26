import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/message_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class NotificationMessageDetailsPage extends StatefulWidget {
  final MessageEntity message;

  NotificationMessageDetailsPage({this.message});

  @override
  _NotificationMessageDetailsPageState createState() => _NotificationMessageDetailsPageState();
}

class _NotificationMessageDetailsPageState extends State<NotificationMessageDetailsPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildMessage(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'account_notification_message_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: pageStyle.deviceWidth,
          padding: EdgeInsets.symmetric(
            horizontal: pageStyle.unitWidth * 10,
            vertical: pageStyle.unitHeight * 10,
          ),
          margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 4),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.message.title,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 13,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    widget.message.time,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 9,
                    ),
                  ),
                ],
              ),
              SizedBox(height: pageStyle.unitHeight * 10),
              Text(
                widget.message.content,
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 13,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
