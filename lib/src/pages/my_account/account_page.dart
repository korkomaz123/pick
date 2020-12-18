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
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'update_profile/bloc/profile_bloc.dart';
import 'widgets/about_us_item.dart';
import 'widgets/change_notification_setting_item.dart';
import 'widgets/change_password_item.dart';
import 'widgets/contact_us_item.dart';
import 'widgets/get_notification_messages_item.dart';
import 'widgets/language_setting_item.dart';
import 'widgets/logout_item.dart';
import 'widgets/order_history_item.dart';
import 'widgets/rate_app_item.dart';
import 'widgets/terms_item.dart';
import 'widgets/wishlist_item.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool getNotification = true;

  PageStyle pageStyle;
  SnackBarService snackBarService;
  ProgressService progressService;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
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
            user != null ? _buildAccountProfile() : SizedBox.shrink(),
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
          user != null
              ? Container(
                  width: pageStyle.unitWidth * 107,
                  height: pageStyle.unitWidth * 107,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: user.profileUrl.isEmpty
                          ? AssetImage('lib/public/images/profile.png')
                          : NetworkImage(user.profileUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  ),
                )
              : Container(
                  width: pageStyle.unitWidth * 107,
                  height: pageStyle.unitWidth * 107,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'lib/public/icons/icon2.svg',
                    width: pageStyle.unitWidth * 67,
                  ),
                ),
          user != null
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: pageStyle.unitWidth * 30),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.firstName,
                              style: mediumTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: pageStyle.unitFontSize * 23,
                              ),
                            ),
                            SizedBox(height: pageStyle.unitHeight * 6),
                            Text(
                              user.lastName,
                              style: mediumTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: pageStyle.unitFontSize * 23,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: pageStyle.unitWidth * 30),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'welcome'.tr(),
                              style: mediumTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: pageStyle.unitFontSize * 26,
                              ),
                            ),
                            SizedBox(height: pageStyle.unitHeight * 6),
                            InkWell(
                              onTap: () => _login(),
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: pageStyle.unitHeight * 10,
                                ),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      logoutIcon,
                                      height: pageStyle.unitHeight * 15,
                                    ),
                                    SizedBox(width: pageStyle.unitWidth * 4),
                                    Text(
                                      'login'.tr(),
                                      style: mediumTextStyle.copyWith(
                                        fontSize: pageStyle.unitFontSize * 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
                  user.email,
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
          user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'account_general_setting_title'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 18,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 10),
                    WishlistItem(
                      pageStyle: pageStyle,
                      snackBarService: snackBarService,
                    ),
                    ChangeNotificationSettingItem(
                      pageStyle: pageStyle,
                      snackBarService: snackBarService,
                    ),
                    GetNotificationMessagesItem(pageStyle: pageStyle),
                    SizedBox(height: pageStyle.unitHeight * 5),
                  ],
                )
              : SizedBox.shrink(),
          LanguageSettingItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          RateAppItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHistoryItem(pageStyle: pageStyle),
                    SizedBox(height: pageStyle.unitHeight * 5),
                  ],
                )
              : SizedBox.shrink(),
          TermsItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          AboutUsItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChangePasswordItem(pageStyle: pageStyle),
                    SizedBox(height: pageStyle.unitHeight * 5),
                    ContactUsItem(pageStyle: pageStyle),
                    LogoutItem(
                      pageStyle: pageStyle,
                      snackBarService: snackBarService,
                      progressService: progressService,
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    setState(() {});
  }
}
