import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'address_form.dart';

class PaymentAddress extends StatefulWidget {
  @override
  _PaymentAddressState createState() => _PaymentAddressState();
}

class _PaymentAddressState extends State<PaymentAddress> {
  AddressChangeNotifier addressChangeNotifier;

  FlushBarService flushBarService;
  ProgressService progressService;

  final dataKey = GlobalKey();

  _loadData() async {
    if (user?.token == null) {
      addressChangeNotifier.initialize();
      await addressChangeNotifier.loadGuestAddress();
    } else if (user?.token != null &&
        (addressChangeNotifier.addressesMap == null ||
            addressChangeNotifier.addressesMap.isEmpty)) {
      addressChangeNotifier.initialize();
      await addressChangeNotifier.loadAddresses(user.token);
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Scrollable.ensureVisible(dataKey.currentContext);
    // });
  }

  @override
  void initState() {
    super.initState();

    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);
    addressChangeNotifier = context.read<AddressChangeNotifier>();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressChangeNotifier>(
      builder: (_, model, __) {
        addressChangeNotifier = model;
        return Container(
          width: designWidth.w,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: [
              if (model.keys.isNotEmpty || model.guestAddress != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'shipment_address_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          color: greyDarkColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      if (user?.token != null ||
                          model.guestAddress == null) ...[
                        InkWell(
                          onTap: _onAddNewAddress,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 18.sp,
                                color: primaryColor,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'add_new_address_button_title'.tr(),
                                style: mediumTextStyle.copyWith(
                                  fontSize: 12.sp,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (user?.token != null) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        model.keys.length,
                        (index) {
                          String key = model.keys[index];
                          return _buildAddressCard(key);
                        },
                      ),
                    ),
                  ),
                ] else ...[
                  _buildGuestAddressCard()
                ],
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(addressIcon, height: 80.h),
                    SizedBox(width: 30.w),
                    Column(
                      children: [
                        Text(
                          'shipment_address_title'.tr(),
                          style: mediumTextStyle.copyWith(
                            color: greyDarkColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'no_saved_addresses'.tr(),
                          style: mediumTextStyle.copyWith(fontSize: 12.sp),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          width: 126.w,
                          height: 28.h,
                          child: MarkaaTextButton(
                            title: 'add_new_address_button_title'.tr(),
                            titleSize: 10.sp,
                            titleColor: Colors.white,
                            buttonColor: primaryColor,
                            borderColor: Colors.transparent,
                            onPressed: _onAddNewAddress,
                            isBold: true,
                            radius: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(String key) {
    final address = addressChangeNotifier.addressesMap[key];
    final defaultAddress = addressChangeNotifier.defaultAddress;
    return InkWell(
      onTap: () => _onUpdateAddress(key),
      child: Container(
        key: address.addressId == defaultAddress?.addressId ? dataKey : null,
        width: 300.w,
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.street,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Block No.${address.company}, ' +
                          address.city +
                          ', ' +
                          address.country,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'phone_number_hint'.tr() + ': ' + address.phoneNumber,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Radio(
                value: address.addressId,
                groupValue:
                    addressChangeNotifier?.defaultAddress?.addressId ?? '',
                activeColor: primaryColor,
                onChanged: (value) => _onUpdateAddress(value),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(editIcon),
                onPressed: () => _onEditAddress(address),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestAddressCard() {
    final address = addressChangeNotifier.guestAddress;
    return Container(
      width: 355.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.street,
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Block No.${address.company}, ' +
                        address.city +
                        ', ' +
                        address.country,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'phone_number_hint'.tr() + ': ' + address.phoneNumber,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: SvgPicture.asset(editIcon),
              onPressed: _onUpdateGuestAddress,
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdateAddress(String key) async {
    final address = addressChangeNotifier.addressesMap[key];
    address.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    await addressChangeNotifier.updateAddress(user.token, address,
        onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
  }

  void _onAddNewAddress() async {
    showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 15.sp,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          minHeight: designHeight.h - 100.h,
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return AddressForm();
          },
        );
      },
    );
  }

  void _onEditAddress(AddressEntity address) async {
    showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 15.sp,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          minHeight: designHeight.h - 100.h,
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return AddressForm(params: {'address': address});
          },
        );
      },
    );
  }

  void _onUpdateGuestAddress() async {
    showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 15.sp,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          minHeight: designHeight.h - 100.h,
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return AddressForm(
              params: {
                'address': addressChangeNotifier.guestAddress,
              },
            );
          },
        );
      },
    );
  }

  _onProcess() {
    progressService.showProgress();
  }

  _onSuccess() {
    progressService.hideProgress();
  }

  _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }
}
