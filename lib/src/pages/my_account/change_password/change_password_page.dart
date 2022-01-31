import 'package:markaa/src/change_notifier/account_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';

import 'widgets/update_password_success_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late ProgressService progressService;
  late FlushBarService flushBarService;
  late AccountChangeNotifier _accountChangeNotifier;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    _accountChangeNotifier = context.read<AccountChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: SecondaryAppBar(title: 'account_update_profile_title'.tr()),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              _buildOldPassword(),
              SizedBox(height: 10.h),
              _buildNewPassword(),
              SizedBox(height: 10.h),
              _buildConfirmPassword(),
              SizedBox(height: 10.h),
              _buildUpdateButton(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildOldPassword() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: oldPasswordController,
        space: 4.h,
        radius: 4,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'old_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) => value!.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildNewPassword() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: newPasswordController,
        space: 4.h,
        radius: 4,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'new_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) => value!.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: confirmPasswordController,
        space: 4.h,
        radius: 4,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'confirm_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'required_field'.tr();
          } else if (value != newPasswordController.text) {
            return 'match_error'.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MarkaaTextButton(
        title: 'update_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: Colors.white,
        buttonColor: primarySwatchColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSave(),
        radius: 0,
      ),
    );
  }

  void _onSave() {
    if (formKey.currentState!.validate()) {
      _accountChangeNotifier.updatePassword(user!.token, oldPasswordController.text, newPasswordController.text,
          onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  _onProcess() {
    progressService.showProgress();
  }

  _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  _onSuccess() async {
    progressService.hideProgress();
    await showDialog(
      context: context,
      builder: (context) {
        return UpdatePasswordSuccessDialog();
      },
    );
    Navigator.pop(context);
  }
}
