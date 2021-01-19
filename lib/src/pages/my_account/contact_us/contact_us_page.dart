import 'package:markaa/src/components/ciga_app_bar.dart';
import 'package:markaa/src/components/ciga_bottom_bar.dart';
import 'package:markaa/src/components/ciga_side_menu.dart';
import 'package:markaa/src/components/ciga_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:string_validator/string_validator.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  SettingBloc settingBloc;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;

  @override
  void initState() {
    super.initState();
    settingBloc = context.read<SettingBloc>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    firstNameController.text = user.firstName;
    emailController.text = user.email;
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      drawer: CigaSideMenu(pageStyle: pageStyle),
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is ContactUsSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is ContactUsSubmittedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
          if (state is ContactUsSubmittedSuccess) {
            progressService.hideProgress();
            Navigator.pushReplacementNamed(context, Routes.contactUsSuccess);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar(),
              _buildContactUsForm(),
            ],
          );
        },
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

  Widget _buildContactUsForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildFirstName(),
              _buildPhoneNumber(),
              _buildEmail(),
              SizedBox(height: pageStyle.unitHeight * 50),
              _buildMessageTitle(),
              _buildMessage(),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: TextFormField(
        controller: firstNameController,
        style: mediumTextStyle.copyWith(
          color: greyColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'first_name'.tr(),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_field'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: TextFormField(
        controller: phoneNumberController,
        style: mediumTextStyle.copyWith(
          color: greyColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'phone_number_hint'.tr(),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_field'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(
          color: greyColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'email_hint'.tr(),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_field'.tr();
          } else if (!isEmail(value)) {
            return 'invalid_email'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildMessageTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: Text(
        'message_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: TextFormField(
        controller: messageController,
        style: mediumTextStyle.copyWith(
          color: greyColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          hintText: 'message_hint'.tr(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: greyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: greyColor),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_field'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.text,
        maxLines: 6,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 80,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: CigaTextButton(
        title: 'send_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSubmit(),
        radius: 30,
      ),
    );
  }

  void _onSubmit() {
    if (formKey.currentState.validate()) {
      settingBloc.add(ContactUsSubmitted(
        name: firstNameController.text,
        phone: phoneNumberController.text,
        email: emailController.text,
        comment: messageController.text,
      ));
    }
  }
}
