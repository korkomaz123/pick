import 'dart:io';
import 'dart:typed_data';

import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/services/image_custom_picker_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';

import 'update_profile/bloc/profile_bloc.dart';
import 'widgets/about_us_item.dart';
import 'widgets/change_notification_setting_item.dart';
import 'widgets/change_password_item.dart';
import 'widgets/contact_us_item.dart';
// import 'widgets/get_notification_messages_item.dart';
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

  File imageFile;
  String name;
  Uint8List image;
  ImageCustomPickerService imageCustomPickerService;

  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    imageCustomPickerService = ImageCustomPickerService(
      context: context,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      video: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      drawerEnableOpenDragGesture: false,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileImageUpdatedInProcess) {
            progressService.showProgress();
          }
          if (state is ProfileImageUpdatedSuccess) {
            progressService.hideProgress();
          }
          if (state is ProfileImageUpdatedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileImageUpdatedSuccess) {
            user.profileUrl = state.url;
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildAccountPicture(),
                Divider(color: greyColor, thickness: 0.5),
                user != null ? _buildAccountProfile() : SizedBox.shrink(),
                _buildAccountGeneralSetting(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(
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
            child: Stack(
              children: [
                if (user != null) ...[
                  Container(
                    width: pageStyle.unitWidth * 107,
                    height: pageStyle.unitWidth * 107,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: user.profileUrl.isEmpty ? AssetImage('lib/public/images/profile.png') : NetworkImage(user.profileUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                ] else ...[
                  Container(
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
                  )
                ],
                if (user != null) ...[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () => _onChangeImage(),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: lang == 'en' ? pageStyle.unitHeight * 10 : 0,
                          left: lang == 'ar' ? pageStyle.unitHeight * 10 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(addIcon),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (user != null) ...[
            Expanded(
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
          ] else ...[
            Expanded(
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
            )
          ],
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
          if (user != null) ...[
            Column(
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
                // GetNotificationMessagesItem(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 5),
              ],
            )
          ],
          LanguageSettingItem(),
          SizedBox(height: pageStyle.unitHeight * 5),
          RateAppItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          if (user != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderHistoryItem(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 5),
              ],
            )
          ],
          SizedBox(height: pageStyle.unitHeight * 5),
          if (user != null) ...[
            Column(
              children: [
                ChangePasswordItem(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 5),
              ],
            )
          ],
          AboutUsItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          TermsItem(pageStyle: pageStyle),
          SizedBox(height: pageStyle.unitHeight * 5),
          ContactUsItem(pageStyle: pageStyle),
          if (user != null) ...[
            LogoutItem(
              pageStyle: pageStyle,
              snackBarService: snackBarService,
              progressService: progressService,
            )
          ],
        ],
      ),
    );
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    setState(() {});
  }

  void _onChangeImage() async {
    imageFile = await imageCustomPickerService.getImageWithDialog();
    if (imageFile != null) {
      name = imageFile.path.split('/').last;
      image = imageFile.readAsBytesSync();
      profileBloc.add(ProfileImageUpdated(
        token: user.token,
        image: image,
        name: name,
      ));
    }
  }
}
