import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
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
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  SettingBloc settingBloc;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    settingBloc = context.read<SettingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is PasswordUpdatedInProcess) {
            progressService.showProgress();
          }
          if (state is PasswordUpdatedSuccess) {
            progressService.hideProgress();
            _showSuccessDialog();
          }
          if (state is PasswordUpdatedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: pageStyle.unitHeight * 30),
                        _buildOldPassword(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildNewPassword(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildConfirmPassword(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildUpdateButton(),
                        SizedBox(height: pageStyle.unitHeight * 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: pageStyle.unitHeight * 50,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'account_update_profile_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildOldPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: oldPasswordController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'old_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildNewPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: newPasswordController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'new_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: confirmPasswordController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'confirm_password_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
        validator: (value) {
          if (value.isEmpty) {
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
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: MarkaaTextButton(
        title: 'update_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSave(),
        radius: 0,
      ),
    );
  }

  void _onSave() {
    if (formKey.currentState.validate()) {
      settingBloc.add(PasswordUpdated(
        token: user.token,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      ));
    }
  }

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return UpdatePasswordSuccessDialog(pageStyle: pageStyle);
      },
    );
    Navigator.pop(context);
  }
}
