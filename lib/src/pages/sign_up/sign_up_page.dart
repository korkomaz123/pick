import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/user_entity.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/extensions/string_extension.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode fullnameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  bool agreeTerms = false;

  late AuthChangeNotifier authChangeNotifier;
  late HomeChangeNotifier homeChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;

  final LocalStorageRepository localRepository = LocalStorageRepository();

  late ProgressService progressService;
  late FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    authChangeNotifier = context.read<AuthChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  void _onSignUpSuccess(UserEntity newUser) async {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.register);
    Adjust.trackEvent(adjustEvent);
    user = newUser;

    await localRepository.setToken(newUser.token);
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.transferCartItems();
    await myCartChangeNotifier.getCartItems(lang);
    await homeChangeNotifier.loadRecentlyViewedCustomer();

    progressService.hideProgress();
    Navigator.pop(context);
    if (!widget.isFromCheckout) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 180.h,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: SvgPicture.asset(hLogoIcon, width: 160.w),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40.h),
                _buildFullName(),
                SizedBox(height: 10),
                _buildPhoneNumber(),
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
        ),
      ),
    );
  }

  Widget _buildFullName() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: TextFormField(
        controller: fullNameController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        focusNode: fullnameNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => phoneNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'full_name'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'required_field'.tr();
          } else if (!value.isValidName) {
            return 'full_name_issue'.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: TextFormField(
        controller: phoneNumberController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        focusNode: phoneNode,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => emailNode.requestFocus(),
        maxLength: 9,
        buildCounter: (
          BuildContext context, {
          int? currentLength,
          int? maxLength,
          bool? isFocused,
        }) =>
            null,
        decoration: InputDecoration(
          hintText: 'phone_number_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
          if (value!.isEmpty) {
            return 'required_field'.tr();
          } else if (!isLength(value, 8, 9)) {
            return 'invalid_length_phone_number'.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        focusNode: emailNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => passNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'email_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
          if (value!.isEmpty) {
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
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: passwordController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        focusNode: passNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: () => passNode.unfocus(),
        decoration: InputDecoration(
          hintText: 'password_hint'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
            onTap: () => passwordController.clear(),
            child: Text('reset'.tr()),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
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
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          if (agreeTerms) ...[
            IconButton(
              onPressed: () {
                agreeTerms = false;
                setState(() {});
              },
              icon: Icon(Icons.check, color: Colors.orange),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                agreeTerms = true;
                setState(() {});
              },
              icon: Icon(Icons.check_box_outline_blank, color: Colors.orange),
            ),
          ],
          Row(
            children: [
              Text(
                'prefix_agree_terms'.tr() + ' ',
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              InkWell(
                onTap: () => _onPrivacyPolicy(),
                child: Text(
                  'suffix_agree_terms'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: Colors.white54,
                    fontSize: 16.sp,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: 375.w,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MarkaaTextButton(
        title: 'create_account'.tr(),
        titleSize: 18.sp,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _onSignUp(),
        radius: 30.sp,
      ),
    );
  }

  Widget _buildSignInPhase() {
    return Container(
      width: 375.w,
      alignment: Alignment.center,
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'login_account'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 17.sp,
          ),
        ),
      ),
    );
  }

  _onSignUp() {
    if (_formKey.currentState!.validate()) {
      if (agreeTerms) {
        String fullName = fullNameController.text.trim();
        String firstName = fullName.split(' ')[0];
        String lastName = fullName.split(' ')[1];
        authChangeNotifier.signUp(
          firstName,
          lastName,
          phoneNumberController.text,
          emailController.text,
          passwordController.text,
          onProcess: _onProcess,
          onSuccess: _onSignUpSuccess,
          onFailure: _onFailure,
        );
      } else {
        flushBarService.showErrorDialog('ask_agree_privacy_policy'.tr());
      }
    }
  }

  _onProcess() {
    progressService.showProgress();
  }

  _onFailure(message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  void _onPrivacyPolicy() async {
    String url = EndPoints.privacyAndPolicy;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      flushBarService.showErrorDialog('can_not_launch_url'.tr());
    }
  }
}
