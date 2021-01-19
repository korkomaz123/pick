import 'dart:io';
import 'dart:typed_data';

import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/image_custom_picker_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'bloc/profile_bloc.dart';
import 'widgets/update_profile_success_dialog.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File imageFile;
  String name;
  Uint8List image;
  ImageCustomPickerService imageCustomPickerService;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    imageCustomPickerService = ImageCustomPickerService(
      context: context,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      video: false,
    );
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    profileBloc = context.read<ProfileBloc>();
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    phoneNumberController.text = user?.phoneNumber;
    emailController.text = user.email;
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileImageUpdatedInProcess ||
              state is ProfileInformationUpdatedInProcess) {
            progressService.showProgress();
          }
          if (state is ProfileImageUpdatedSuccess) {
            progressService.hideProgress();
          }
          if (state is ProfileImageUpdatedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
          if (state is ProfileInformationUpdatedSuccess) {
            progressService.hideProgress();
            user.firstName = firstNameController.text;
            user.lastName = lastNameController.text;
            user.phoneNumber = phoneNumberController.text;
            _showSuccessDialog();
          }
          if (state is ProfileInformationUpdatedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileImageUpdatedSuccess) {
            user.profileUrl = state.url;
          }
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildProfilePicture(),
                        _buildEmail(),
                        _buildFirstName(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildLastName(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildPhoneNumber(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                        _buildEmailAddress(),
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

  Widget _buildProfilePicture() {
    return Center(
      child: Container(
        width: pageStyle.unitWidth * 140,
        height: pageStyle.unitHeight * 140,
        margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
        child: Stack(
          children: [
            Container(
              width: pageStyle.unitWidth * 140,
              height: pageStyle.unitHeight * 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: user.profileUrl.isNotEmpty
                      ? NetworkImage(user.profileUrl)
                      : AssetImage('lib/public/images/profile.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () => _onChangeImage(),
                child: Container(
                  margin: EdgeInsets.only(right: pageStyle.unitWidth * 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(addIcon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Row(
        children: [
          Container(
            width: pageStyle.unitWidth * 22,
            height: pageStyle.unitHeight * 22,
            child: SvgPicture.asset(emailIcon),
          ),
          SizedBox(width: pageStyle.unitWidth * 10),
          Text(
            user.email,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: firstNameController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'first_name'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildLastName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: lastNameController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'last_name'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: phoneNumberController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'phone_number_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildEmailAddress() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: MarkaaInputField(
        width: double.infinity,
        controller: emailController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'email_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
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

  void _onChangeImage() async {
    imageFile = await imageCustomPickerService.getImageWithDialog();
    if (imageFile != null) {
      name = imageFile.path.split('/').last;
      image = imageFile.readAsBytesSync();
      profileBloc.add(ProfileImageUpdated(
        token: user.token,
        image: image,
        name: name,
      ));
    }
  }

  void _onSave() {
    profileBloc.add(ProfileInformationUpdated(
      token: user.token,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
    ));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateProfileSuccessDialog(pageStyle: pageStyle);
      },
    );
  }
}
