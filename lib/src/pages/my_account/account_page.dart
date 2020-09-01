import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  PageStyle pageStyle;
  bool getNotification = true;
  String language;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAccountPicture(),
            Divider(color: greyColor, thickness: 0.5),
            _buildAccountProfile(),
            _buildAccountGeneralSetting(),
          ],
        ),
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAccountPicture() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Row(
        children: [
          Container(
            width: pageStyle.unitWidth * 107,
            height: pageStyle.unitWidth * 107,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/public/images/profile.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: pageStyle.unitWidth * 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmed',
                    style: boldTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 23,
                    ),
                  ),
                  SizedBox(height: pageStyle.unitHeight * 6),
                  Text(
                    'Korkomaz',
                    style: boldTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountProfile() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(emailIcon),
            ),
            title: Text(
              'okorkomaz1@gmail.com',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, Routes.updateProfile),
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(profileIcon),
            ),
            title: Text(
              'account_update_profile_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(logoutIcon),
            ),
            title: Text(
              'account_logout_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountGeneralSetting() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'account_general_setting_title'.tr(),
            style: boldTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, Routes.wishlist),
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(wishlistIcon),
            ),
            title: Text(
              'account_wishlist_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(notificationIcon),
            ),
            title: Text(
              'account_get_notification_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Switch(
              value: getNotification,
              onChanged: (value) {
                setState(() {
                  getNotification = value;
                });
              },
              activeColor: primaryColor,
              inactiveTrackColor: Colors.grey.shade200,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(messageIcon),
            ),
            title: Text(
              'account_notification_messages_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(languageIcon),
            ),
            title: Text(
              'account_language_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Container(
              width: pageStyle.unitWidth * 100,
              height: pageStyle.unitHeight * 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: SelectOptionCustom(
                items: ['account_language_ar'.tr(), 'account_language_en'.tr()],
                value: language,
                itemWidth: pageStyle.unitWidth * 50,
                itemHeight: pageStyle.unitHeight * 25,
                itemSpace: 0,
                titleSize: pageStyle.unitFontSize * 12,
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
                  if (language != value) {
                    language = value;
                    if (language == 'account_language_ar') {
                      EasyLocalization.of(context).locale = Locale('en', 'US');
                    } else {
                      EasyLocalization.of(context).locale = Locale('ar', 'AR');
                    }
                    setState(() {});
                  }
                },
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(rateIcon),
            ),
            title: Text(
              'account_rate_app_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, Routes.orderHistory),
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(orderHistoryIcon),
            ),
            title: Text(
              'account_order_history_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(termsIcon),
            ),
            title: Text(
              'account_terms_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(aboutUsIcon),
            ),
            title: Text(
              'account_about_us_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}
