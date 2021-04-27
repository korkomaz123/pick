import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/user_entity.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  final bool isFromCheckout;

  SignUpPage({this.isFromCheckout = false});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode firstnameNode = FocusNode();
  FocusNode lastnameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  bool agreeTerms = false;
  SignInBloc signInBloc;
  HomeChangeNotifier homeChangeNotifier;
  ProgressService progressService;
  FlushBarService flushBarService;
  PageStyle pageStyle;
  final LocalStorageRepository localRepo = LocalStorageRepository();
  MyCartChangeNotifier myCartChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    signInBloc = context.read<SignInBloc>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  void _saveToken(UserEntity loggedInUser) async {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.registerToken);
    Adjust.trackEvent(adjustEvent);
    user = loggedInUser;
    await localRepo.setToken(loggedInUser.token);
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.transferCartItems();
    await myCartChangeNotifier.getCartItems(lang);
    homeChangeNotifier.loadRecentlyViewedCustomer();
    progressService.hideProgress();
    Navigator.pop(context);
    if (!widget.isFromCheckout) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignUpSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is SignUpSubmittedSuccess) {
            _saveToken(state.user);
          }
          if (state is SignUpSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
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
                    alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: pageStyle.unitHeight * 20,
                      bottom: pageStyle.unitHeight * 60,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      hLogoIcon,
                      width: pageStyle.unitWidth * 120,
                      height: pageStyle.unitHeight * 45,
                    ),
                  ),
                  _buildFirstName(),
                  SizedBox(height: 10),
                  _buildLastName(),
                  SizedBox(height: 10),
                  _buildEmail(),
                  SizedBox(height: 10),
                  _buildPassword(),
                  SizedBox(height: 40),
                  _buildTermsAndConditions(),
                  SizedBox(height: 40),
                  _buildSignUpButton(),
                  SizedBox(height: 40),
                  if (!widget.isFromCheckout) ...[_buildSignInPhase()],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: firstNameController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        focusNode: firstnameNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => lastnameNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'first_name'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
        ),
        validator: (value) => value.isNotEmpty ? null : 'required_first_name'.tr(),
      ),
    );
  }

  Widget _buildLastName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: lastNameController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        focusNode: lastnameNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => emailNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'last_name'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
        ),
        validator: (value) => value.isNotEmpty ? null : 'required_last_name'.tr(),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        focusNode: emailNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => passNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'email_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_email'.tr();
          } else if (!isEmail(value)) {
            return 'invalid_email'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: passwordController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        focusNode: passNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => passNode.unfocus(),
        decoration: InputDecoration(
          hintText: 'password_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
          suffix: InkWell(
            onTap: () => null,
            child: Text('reset'.tr()),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_password'.tr();
          } else if (!isLength(value, 6)) {
            return 'short_length_password'.tr();
          }
          return null;
        },
        obscureText: true,
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: CheckboxListTile(
        value: agreeTerms,
        onChanged: (value) {
          agreeTerms = value;
          setState(() {});
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.white,
        title: Row(
          children: [
            Text(
              'prefix_agree_terms'.tr() + ' ',
              style: mediumTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            InkWell(
              onTap: () => _onPrivacyPolicy(),
              child: Text(
                'suffix_agree_terms'.tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white54,
                  fontSize: pageStyle.unitFontSize * 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: MarkaaTextButton(
        title: 'create_account'.tr(),
        titleSize: pageStyle.unitFontSize * 19,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _onSignUp(),
        radius: 10,
      ),
    );
  }

  Widget _buildSignInPhase() {
    return Container(
      width: pageStyle.deviceWidth,
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'login_account'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 17,
          ),
        ),
      ),
    );
  }

  void _onSignUp() {
    if (_formKey.currentState.validate()) {
      signInBloc.add(SignUpSubmitted(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  void _onPrivacyPolicy() async {
    String url = 'https://cigaon.com/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      flushBarService.showErrorMessage(pageStyle, 'can_not_launch_url'.tr());
    }
  }
}
