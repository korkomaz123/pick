import 'package:markaa/src/change_notifier/account_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late ProgressService progressService;
  late FlushBarService flushBarService;
  late AccountChangeNotifier _accountChangeNotifier;

  @override
  void initState() {
    super.initState();
    _accountChangeNotifier = context.read<AccountChangeNotifier>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    firstNameController.text = user?.firstName ?? '';
    emailController.text = user?.email ?? '';
    phoneNumberController.text = user?.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: SecondaryAppBar(title: 'account_contact_us_title'.tr()),
      body: _buildContactUsForm(),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildContactUsForm() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildFirstName(),
            _buildPhoneNumber(),
            _buildEmail(),
            _buildMessageTitle(),
            _buildMessage(),
            _buildSendButton(),
            _buildCallUs(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: TextFormField(
        controller: firstNameController,
        style: mediumTextStyle.copyWith(color: greyColor, fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'first_name'.tr(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
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
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: TextFormField(
        controller: phoneNumberController,
        style: mediumTextStyle.copyWith(color: greyColor, fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'phone_number_hint'.tr(),
        ),
        maxLength: 9,
        buildCounter: (
          BuildContext context, {
          int? currentLength,
          int? maxLength,
          bool? isFocused,
        }) =>
            null,
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_field'.tr();
          } else if (!isLength(value, 8, 9)) {
            return 'invalid_length_phone_number'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(color: greyColor, fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'email_hint'.tr(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Text(
        'message_title'.tr(),
        style: mediumTextStyle.copyWith(color: greyColor, fontSize: 14.sp),
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: messageController,
        style: mediumTextStyle.copyWith(color: greyColor, fontSize: 14.sp),
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
          if (value!.isEmpty) {
            return 'required_field'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.text,
        maxLines: 3,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.only(left: 80.w, right: 80.w, top: 20.h),
      child: MarkaaTextButton(
        title: 'send_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: Colors.white,
        buttonColor: primarySwatchColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSubmit(),
        radius: 30,
      ),
    );
  }

  Widget _buildCallUs() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 10.h),
      child: MarkaaTextButton(
        title: 'call_us'.tr(),
        titleSize: 14.sp,
        titleColor: Colors.white,
        buttonColor: Colors.orange,
        borderColor: Colors.transparent,
        onPressed: () => _onCallUs(),
        radius: 30,
      ),
    );
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      _accountChangeNotifier.contactSupport(
        firstNameController.text,
        phoneNumberController.text,
        emailController.text,
        messageController.text,
        onProcess: () => progressService.showProgress(),
        onSuccess: () {
          progressService.hideProgress();
          Navigator.pushReplacementNamed(context, Routes.contactUsSuccess);
        },
        onFailure: (message) {
          progressService.hideProgress();
          flushBarService.showErrorDialog(message);
        },
      );
    }
  }

  void _onCallUs() async {
    if (await canLaunch('tel:+96522285188')) {
      await launch('tel:+96522285188');
    }
  }
}
