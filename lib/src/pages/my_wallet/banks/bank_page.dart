import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';

import 'package:markaa/src/data/models/index.dart';

import 'package:markaa/src/pages/my_wallet/my_wallet_details/widgets/my_wallet_details_header.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/theme/icons.dart';

class BankPage extends StatefulWidget {
  final BankAccountEntity account;

  BankPage({this.account});

  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bankController = TextEditingController();
  final _nameController = TextEditingController();
  final _iBanController = TextEditingController();

  bool isSave = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget?.account?.title;
    _bankController.text = widget?.account?.bank;
    _nameController.text = widget?.account?.name;
    _iBanController.text = widget?.account?.iBan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletDetailsHeader(),
      body: SingleChildScrollView(
        child: Container(
          color: greyLightColor,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  'create_new_account'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 20.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildBank(),
                SizedBox(height: 10.h),
                _buildName(),
                SizedBox(height: 10.h),
                _buildIBan(),
                SizedBox(height: 20.h),
                _buildSaveItem(),
                if (isSave) ...[
                  SizedBox(height: 10.h),
                  _buildTitle(),
                ],
                SizedBox(height: 20.h),
                _buildButton(),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBank() {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 50.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _bankController,
        space: 4.h,
        radius: 4,
        fontSize: 14.sp,
        fontColor: greyDarkColor,
        label: 'select_bank_hint'.tr(),
        labelColor: primaryColor,
        labelSize: 14.sp,
        fillColor: Colors.white,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildName() {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 50.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _nameController,
        space: 4.h,
        radius: 4,
        fontSize: 14.sp,
        fontColor: greyDarkColor,
        label: 'name_hint'.tr(),
        labelColor: primaryColor,
        labelSize: 14.sp,
        fillColor: Colors.white,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildIBan() {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 50.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _iBanController,
        space: 4.h,
        radius: 4,
        fontSize: 14.sp,
        fontColor: greyDarkColor,
        label: 'iban_hint'.tr(),
        labelColor: primaryColor,
        labelSize: 14.sp,
        fillColor: Colors.white,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildSaveItem() {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 50.sp),
      child: InkWell(
        onTap: () => setState(() {
          isSave = !isSave;
        }),
        child: Row(
          children: [
            SvgPicture.asset(
                isSave ? boldCheckBoxCheckedIcon : boldCheckBoxUncheckedIcon),
            SizedBox(width: 5.w),
            Text(
              'save_account_info'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 50.sp),
      child: MarkaaInputField(
        width: double.infinity,
        controller: _titleController,
        space: 4.h,
        radius: 4,
        fontSize: 14.sp,
        fontColor: greyDarkColor,
        label: 'account_title_hint'.tr(),
        labelColor: darkColor,
        labelSize: 14.sp,
        fillColor: Colors.white,
        bordered: false,
        validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: 276.w,
      height: 48.h,
      child: MarkaaTextButton(
        onPressed: () => null,
        title: 'send_amount'.tr(),
        titleColor: Colors.white,
        titleSize: 15.sp,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        radius: 8.sp,
        isBold: true,
      ),
    );
  }
}
