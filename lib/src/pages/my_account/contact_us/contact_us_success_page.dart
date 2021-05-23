import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsSuccessPage extends StatefulWidget {
  @override
  _ContactUsSuccessPageState createState() => _ContactUsSuccessPageState();
}

class _ContactUsSuccessPageState extends State<ContactUsSuccessPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildContactUsSucceed(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 22.sp),
      ),
      centerTitle: true,
      title: Text(
        'account_contact_us_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
    );
  }

  Widget _buildContactUsSucceed() {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'checkout_ordered_success_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 34.sp,
                    ),
                  ),
                  Container(
                    width: 25.w,
                    height: 25.h,
                    child: SvgPicture.asset(orderedSuccessIcon),
                  ),
                ],
              ),
            ),
            Text(
              'message_sent_prefix'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 14.sp,
              ),
            ),
            Text(
              'message_sent_suffix'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 14.sp,
              ),
            ),
            _buildBackToShopButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: 30.h,
        horizontal: 30.w,
      ),
      child: MarkaaTextButton(
        title: 'checkout_back_shop_button_title'.tr(),
        titleSize: 17.sp,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: greyColor,
        onPressed: () => Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        ),
        radius: 0,
      ),
    );
  }
}
