import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
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
    language = EasyLocalization.of(context).locale.languageCode.toUpperCase();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      drawerEnableOpenDragGesture: false,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 5),
            child: Row(
              children: [
                Container(
                  width: pageStyle.unitWidth * 22,
                  height: pageStyle.unitHeight * 22,
                  child: SvgPicture.asset(emailIcon),
                ),
                SizedBox(width: pageStyle.unitWidth * 10),
                Text(
                  'okorkomaz1@gmail.com',
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.updateProfile),
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
                        child: SvgPicture.asset(profileIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_update_profile_title'.tr(),
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
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.shippingAddress),
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
                        child: SvgPicture.asset(shippingAddressIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'shipping_address_title'.tr(),
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
          SizedBox(height: pageStyle.unitHeight * 10),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.wishlist),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: pageStyle.unitHeight * 5),
              child: Row(
                children: [
                  Container(
                    width: pageStyle.unitWidth * 22,
                    height: pageStyle.unitHeight * 22,
                    child: SvgPicture.asset(wishlistIcon),
                  ),
                  SizedBox(width: pageStyle.unitWidth * 10),
                  Text(
                    'account_wishlist_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '10 ' + 'items'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 16,
                      color: primaryColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: pageStyle.unitFontSize * 20,
                    color: greyDarkColor,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => null,
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: pageStyle.unitWidth * 22,
                        height: pageStyle.unitHeight * 22,
                        child: SvgPicture.asset(notificationIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_get_notification_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 16,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: getNotification,
                    onChanged: (value) {
                      setState(() {
                        getNotification = value;
                      });
                    },
                    activeColor: primaryColor,
                    inactiveTrackColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
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
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => null,
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
                        child: SvgPicture.asset(languageIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_language_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: pageStyle.unitWidth * 100,
                    height: pageStyle.unitHeight * 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: SelectOptionCustom(
                      items: ['EN', 'AR'],
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
                          if (language == 'EN') {
                            EasyLocalization.of(context).locale =
                                EasyLocalization.of(context)
                                    .supportedLocales
                                    .first;
                            lang = 'en';
                          } else {
                            EasyLocalization.of(context).locale =
                                EasyLocalization.of(context)
                                    .supportedLocales
                                    .last;
                            lang = 'ar';
                          }
                          setState(() {});
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => null,
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
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.orderHistory),
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
                        child: SvgPicture.asset(orderHistoryIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_order_history_title'.tr(),
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
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.terms),
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
                        child: SvgPicture.asset(termsIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_terms_title'.tr(),
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
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.aboutUs),
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
                        child: SvgPicture.asset(aboutUsIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_about_us_title'.tr(),
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
          ),
          SizedBox(height: pageStyle.unitHeight * 5),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.contactUs),
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
                        child: SvgPicture.asset(emailIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_contact_us_title'.tr(),
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
          ),
          InkWell(
            onTap: () => null,
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
                        child: SvgPicture.asset(logoutIcon),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      Text(
                        'account_logout'.tr(),
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
          ),
        ],
      ),
    );
  }
}
