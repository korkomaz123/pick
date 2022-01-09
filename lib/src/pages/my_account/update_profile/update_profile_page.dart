import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/account_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/extensions/string_extension.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/image_custom_picker_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:string_validator/string_validator.dart';

import 'widgets/update_profile_success_dialog.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  String? _name;
  Uint8List? _image;
  late ImageCustomPickerService _imageCustomPickerService;
  late ProgressService _progressService;
  late FlushBarService _flushBarService;
  late AccountChangeNotifier _accountChangeNotifier;

  @override
  void initState() {
    super.initState();
    _accountChangeNotifier = context.read<AccountChangeNotifier>();
    _imageCustomPickerService = ImageCustomPickerService(
      context: context,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      video: false,
    );
    _progressService = ProgressService(context: context);
    _flushBarService = FlushBarService(context: context);
    _fullNameController.text = user!.firstName + ' ' + user!.lastName;
    _phoneNumberController.text = user?.phoneNumber ?? '';
    _emailController.text = user!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: _scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: Consumer<AccountChangeNotifier>(
        builder: (_, __, ___) {
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfilePicture(),
                        _buildEmail(),
                        _buildFullName(),
                        SizedBox(height: 10.h),
                        _buildPhoneNumber(),
                        SizedBox(height: 10.h),
                        _buildEmailAddress(),
                        SizedBox(height: 30.h),
                        _buildUpdateButton(),
                        SizedBox(height: 30.h),
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
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50.h,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 22.sp),
      ),
      centerTitle: true,
      title: Text(
        'account_update_profile_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Container(
        width: 140.w,
        height: 140.w,
        margin: EdgeInsets.symmetric(vertical: 30.h),
        child: Stack(
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: user?.profileUrl != null && user?.profileUrl != ''
                      ? CachedNetworkImageProvider(
                          user!.profileUrl!,
                          errorListener: () => print('Image loading error'),
                        ) as ImageProvider<Object>
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
                  margin: EdgeInsets.only(
                    right: lang == 'en' ? 20.h : 0,
                    left: lang == 'ar' ? 20.h : 0,
                  ),
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
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 22.w,
            height: 22.h,
            child: SvgPicture.asset(emailIcon),
          ),
          SizedBox(width: 10.w),
          Text(
            user!.email,
            style: mediumTextStyle.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFullName() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _fullNameController,
        space: 4.h,
        radius: 4.sp,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'full_name'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
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
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _phoneNumberController,
        space: 4.h,
        radius: 4.sp,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'phone_number_hint'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
        maxLength: 9,
        validator: (String? value) {
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

  Widget _buildEmailAddress() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _emailController,
        space: 4.h,
        radius: 4.sp,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'email_hint'.tr(),
        labelColor: greyColor,
        labelSize: 16.sp,
        fillColor: Colors.grey.shade300,
        bordered: false,
        validator: (value) => value!.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MarkaaTextButton(
        title: 'update_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSave(),
        radius: 30,
        isBold: true,
      ),
    );
  }

  void _onChangeImage() async {
    _imageFile = await _imageCustomPickerService.getImageWithDialog();
    if (_imageFile != null) {
      _name = _imageFile!.path.split('/').last;
      _image = _imageFile!.readAsBytesSync();
      _accountChangeNotifier.updateProfileImage(user!.token, _image!, _name!,
          onProcess: _onProcess, onSuccess: _onProfileImageUpdated, onFailure: _onFailure);
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      String fullName = _fullNameController.text.trim();
      _accountChangeNotifier.updateProfileInfo(
        user!.token,
        fullName.split(' ')[0],
        fullName.split(' ')[1],
        _phoneNumberController.text,
        _emailController.text,
        onProcess: _onProcess,
        onSuccess: _onProfileInfoUpdated,
        onFailure: _onFailure,
      );
    }
  }

  void _onProcess() {
    _progressService.showProgress();
  }

  void _onFailure(String message) {
    _progressService.hideProgress();
    _flushBarService.showErrorDialog(message);
  }

  void _onProfileImageUpdated(String url) {
    user!.profileUrl = url;
    _progressService.hideProgress();
  }

  void _onProfileInfoUpdated() {
    _progressService.hideProgress();
    String fullName = _fullNameController.text.trim();
    user!.firstName = fullName.split(' ')[0];
    user!.lastName = fullName.split(' ')[1];
    user!.phoneNumber = _phoneNumberController.text;
    showDialog(
      context: context,
      builder: (context) => UpdateProfileSuccessDialog(),
    );
  }
}
