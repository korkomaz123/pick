import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/forgot_password/widgets/new_password_sent_dialog.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:string_validator/string_validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  final bool isFromCheckout;

  ForgotPasswordPage({this.isFromCheckout = false});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is NewPasswordRequestSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is NewPasswordRequestSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showSimpleErrorMessageWithImage(state.message);
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
                    width: 375.w,
                    padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                    alignment: lang == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 60.h, bottom: 120.h),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      hLogoIcon,
                      width: 120.w,
                      height: 45.h,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'forgot_password_title'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
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
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: emailController,
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'email'.tr().toUpperCase(),
          hintStyle: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: 14.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
      width: 375.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: MarkaaTextButton(
        title: 'get_new_password'.tr(),
        titleSize: 16.sp,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _onGetNewPassword(),
        radius: 30,
      ),
    );
  }

  Widget _buildAuthChoiceDivider() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Text(
              'login'.tr(),
              style: mediumTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
          if (!widget.isFromCheckout) ...[
            Container(
              height: 20.h,
              child: VerticalDivider(color: Colors.white, thickness: 0.5),
            ),
            InkWell(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.signUp),
              child: Text(
                'register'.tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
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
        return NewPasswordSentDialog();
      },
    );
    Navigator.pop(context);
  }
}
