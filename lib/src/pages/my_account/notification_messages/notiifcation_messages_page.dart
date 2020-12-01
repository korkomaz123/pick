import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class NotificationMessagesPage extends StatefulWidget {
  @override
  _NotificationMessagesPageState createState() =>
      _NotificationMessagesPageState();
}

class _NotificationMessagesPageState extends State<NotificationMessagesPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildMessageList(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
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
                  width: pageStyle.deviceWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: pageStyle.unitWidth * 10,
                    vertical: pageStyle.unitHeight * 10,
                  ),
                  margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 4),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        width: pageStyle.unitWidth * 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index].time,
                              style: mediumTextStyle.copyWith(
                                fontSize: pageStyle.unitFontSize * 9,
                              ),
                            ),
                            Text(
                              messages[index].title,
                              style: mediumTextStyle.copyWith(
                                fontSize: pageStyle.unitFontSize * 13,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              messages[index].content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: mediumTextStyle.copyWith(
                                fontSize: pageStyle.unitFontSize * 13,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                            size: pageStyle.unitFontSize * 22,
                          ),
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
