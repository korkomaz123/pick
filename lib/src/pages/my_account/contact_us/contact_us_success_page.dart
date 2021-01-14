import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ContactUsSuccessPage extends StatefulWidget {
  @override
  _ContactUsSuccessPageState createState() => _ContactUsSuccessPageState();
}

class _ContactUsSuccessPageState extends State<ContactUsSuccessPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildContactUsSucceed(),
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
        'account_contact_us_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildContactUsSucceed() {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: pageStyle.unitHeight * 100),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'checkout_ordered_success_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 34,
                    ),
                  ),
                  Container(
                    width: pageStyle.unitWidth * 25,
                    height: pageStyle.unitHeight * 25,
                    child: SvgPicture.asset(orderedSuccessIcon),
                  ),
                ],
              ),
            ),
            Text(
              'message_sent_prefix'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
            Text(
              'message_sent_suffix'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 14,
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
        vertical: pageStyle.unitHeight * 30,
        horizontal: pageStyle.unitWidth * 30,
      ),
      child: CigaTextButton(
        title: 'checkout_back_shop_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 17,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: greyColor,
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        ),
        radius: 0,
      ),
    );
  }
}
