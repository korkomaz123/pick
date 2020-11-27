import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/pages/forgot_password/widgets/new_password_sent_dialog.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:string_validator/string_validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  PageStyle pageStyle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  SignInBloc signInBloc;
  ProgressService progressService;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    signInBloc = context.read<SignInBloc>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is NewPasswordRequestSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is NewPasswordRequestSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
          if (state is NewPasswordRequestSubmittedSuccess) {
            progressService.hideProgress();
            _showSuccessDialog();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: pageStyle.deviceWidth,
                    padding: EdgeInsets.only(
                      top: pageStyle.unitHeight * 30,
                      bottom: pageStyle.unitHeight * 30,
                    ),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: pageStyle.unitHeight * 60,
                      bottom: pageStyle.unitHeight * 120,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      hLogoIcon,
                      width: pageStyle.unitWidth * 120,
                      height: pageStyle.unitHeight * 45,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'forgot_password_title'.tr(),
                      style: bookTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildUsernameOrEmail(),
                  SizedBox(height: 40),
                  _buildGetNewPassButton(),
                  SizedBox(height: 60),
                  _buildAuthChoiceDivider(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsernameOrEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: emailController,
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'email'.tr().toUpperCase(),
          hintStyle: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
          errorStyle: bookTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return 'required_email'.tr();
          } else if (!isEmail(value)) {
            return 'invalid_email'.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGetNewPassButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextButton(
        title: 'get_new_password'.tr(),
        titleSize: pageStyle.unitFontSize * 19,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _onGetNewPassword(),
        radius: 10,
      ),
    );
  }

  Widget _buildAuthChoiceDivider() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Text(
              'login'.tr(),
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          ),
          Container(
            height: pageStyle.unitHeight * 20,
            child: VerticalDivider(color: Colors.white, thickness: 0.5),
          ),
          InkWell(
            onTap: () => Navigator.pushReplacementNamed(context, Routes.signUp),
            child: Text(
              'register'.tr(),
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onGetNewPassword() {
    if (_formKey.currentState.validate()) {
      signInBloc.add(NewPasswordRequestSubmitted(email: emailController.text));
    }
  }

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return NewPasswordSentDialog(pageStyle: pageStyle);
      },
    );
    Navigator.pop(context);
  }
}
