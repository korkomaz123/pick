import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/pages/my_wallet/my_wallet_details/widgets/my_wallet_details_header.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';

class BankListPage extends StatefulWidget {
  @override
  _BankListPageState createState() => _BankListPageState();
}

class _BankListPageState extends State<BankListPage> {
  String defaultValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletDetailsHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'select_bank_account'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 20.sp,
                color: primaryColor,
              ),
            ),
            Column(
              children: bankAccounts.map((account) {
                return _buildAccountCard(account);
              }).toList(),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildAccountCard(BankAccountEntity account) {
    return Container(
      width: designWidth.w,
      color: greyLightColor,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: RadioListTile(
        value: account.title,
        groupValue: defaultValue,
        title: Text(
          account.title,
          style: mediumTextStyle.copyWith(fontSize: 18.sp),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: darkColor,
        onChanged: (value) {
          defaultValue = value;
          setState(() {});
        },
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: designWidth.w,
      height: 80.h,
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.addNewBankAccount),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(addIcon, width: 18.w),
                SizedBox(width: 2.w),
                Text(
                  'add_new_bank_account'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: 276.w,
            height: 38.h,
            child: MarkaaTextButton(
              onPressed: () => defaultValue != null ? null : null,
              title: 'send_amount'.tr(),
              titleColor: Colors.white,
              titleSize: 13.sp,
              buttonColor: defaultValue != null ? primaryColor : greyLightColor,
              borderColor:
                  defaultValue != null ? Colors.transparent : Colors.white,
              radius: 8.sp,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}
