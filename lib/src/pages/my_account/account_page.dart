import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
// import 'widgets/my_wallet_item.dart';
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
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
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
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAccountPicture() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Row(
        children: [
          Container(
            width: 107.w,
            height: 107.w,
            child: Stack(
              children: [
                if (user != null) ...[
                  CachedNetworkImage(
                    imageUrl: user?.profileUrl ?? '',
                    imageBuilder: (_, _imageProvider) {
                      return Container(
                        width: 107.w,
                        height: 107.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _imageProvider,
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                    errorWidget: (_, __, ___) {
                      return Container(
                        width: 107.w,
                        height: 107.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/public/images/profile.png'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ] else ...[
                  Container(
                    width: 107.w,
                    height: 107.w,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'lib/public/icons/icon2.svg',
                      width: 67.w,
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
                          right: lang == 'en' ? 10.h : 0,
                          left: lang == 'ar' ? 10.h : 0,
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
                padding: EdgeInsets.only(left: 30.w),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.firstName,
                          style: mediumTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: 23.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          user.lastName,
                          style: mediumTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: 23.sp,
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
                padding: EdgeInsets.only(left: 30.w),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'welcome'.tr(),
                          style: mediumTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: 26.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        InkWell(
                          onTap: () => _login(),
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 10.h,
                            ),
                            width: double.infinity,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  logoutIcon,
                                  height: 15.h,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'login'.tr(),
                                  style: mediumTextStyle.copyWith(
                                    fontSize: 16.sp,
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
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.h,
                  child: SvgPicture.asset(emailIcon),
                ),
                SizedBox(width: 10.w),
                Text(
                  user.email,
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.updateProfile),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.h,
                        child: SvgPicture.asset(profileIcon),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'account_update_profile_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
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
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.h,
                        child: SvgPicture.asset(shippingAddressIcon),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'shipping_address_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
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
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
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
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                WishlistItem(
                  snackBarService: snackBarService,
                ),
                ChangeNotificationSettingItem(
                  snackBarService: snackBarService,
                ),
                // GetNotificationMessagesItem(),
                SizedBox(height: 5.h),
              ],
            )
          ],
          LanguageSettingItem(),
          SizedBox(height: 5.h),
          RateAppItem(),
          SizedBox(height: 5.h),
          if (user != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MyWalletItem(),
                // SizedBox(height: 5.h),
                OrderHistoryItem(),
                SizedBox(height: 5.h),
              ],
            )
          ],
          SizedBox(height: 5.h),
          if (user != null) ...[
            Column(
              children: [
                ChangePasswordItem(),
                SizedBox(height: 5.h),
              ],
            )
          ],
          AboutUsItem(),
          SizedBox(height: 5.h),
          TermsItem(),
          SizedBox(height: 5.h),
          ContactUsItem(),
          if (user != null) ...[
            LogoutItem(
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
