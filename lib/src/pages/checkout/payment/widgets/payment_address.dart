import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
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
  late AddressChangeNotifier addressChangeNotifier;
  late FlushBarService flushBarService;
  late ProgressService progressService;

  final dataKey = GlobalKey();

  _loadData() async {
    if (user == null && addressChangeNotifier.guestAddressesMap.isEmpty) {
      await addressChangeNotifier.loadGuestAddresses();
    } else if (user != null && addressChangeNotifier.customerAddressesMap.isEmpty) {
      await addressChangeNotifier.loadCustomerAddresses(user!.token);
    }
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
              if ((user != null && model.customerAddressKeys.isNotEmpty) ||
                  (user == null && model.guestAddressKeys.isNotEmpty)) ...[
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
                      InkWell(
                        onTap: _onAddNewAddress,
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_outline, size: 18.sp, color: primaryColor),
                            SizedBox(width: 5.w),
                            Text(
                              'add_new_address_button_title'.tr(),
                              style: mediumTextStyle.copyWith(fontSize: 12.sp, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (user != null) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        model.customerAddressKeys.length,
                        (index) {
                          String key = model.customerAddressKeys[index];
                          return _buildAddressCard(model.customerAddressesMap[key]!);
                        },
                      ),
                    ),
                  ),
                ] else ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        model.guestAddressKeys.length,
                        (index) {
                          int key = model.guestAddressKeys[index];
                          return _buildAddressCard(model.guestAddressesMap[key]!);
                        },
                      ),
                    ),
                  ),
                ],
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(addressIcon, height: 80.h),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          ],
                        ),
                      ),
                      Container(
                        height: 24.h,
                        child: MarkaaTextButton(
                          title: 'add_new_address_button_title'.tr(),
                          titleSize: 9.sp,
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
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(AddressEntity address) {
    final defaultAddress =
        user != null ? addressChangeNotifier.customerDefaultAddress : addressChangeNotifier.guestDefaultAddress;
    final isDefault = user != null ? address.addressId == defaultAddress?.addressId : address.id == defaultAddress?.id;
    var groupValue = user != null ? defaultAddress?.addressId : defaultAddress?.id;
    var value = user != null ? address.addressId : address.id;
    return InkWell(
      onTap: () => _onUpdateAddress(value),
      child: Container(
        key: isDefault ? dataKey : null,
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
                      'Block No.${address.company}, ${address.city}, ${address.country}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 12.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'phone_number_hint'.tr() + ': ' + address.phoneNumber!,
                      style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Radio(
                value: value,
                groupValue: groupValue,
                activeColor: primaryColor,
                onChanged: _onUpdateAddress,
              ),
            ),
            if (user == null) ...[
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: SvgPicture.asset(trashIcon),
                  onPressed: () => _onRemoveAddress(address),
                ),
              )
            ],
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

  void _onUpdateAddress(var key) async {
    late AddressEntity address;
    if (user == null) {
      address = addressChangeNotifier.guestAddressesMap[key]!;
    } else {
      address = addressChangeNotifier.customerAddressesMap[key]!;
    }
    address.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    if (user == null) {
      await addressChangeNotifier.changeGuestAddress(false, address.toJson(),
          onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
    } else {
      await addressChangeNotifier.changeCustomerAddress(false, user!.token, address,
          onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
    }
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

  void _onRemoveAddress(AddressEntity address) async {
    final result = await flushBarService.showConfirmDialog(message: 'remove_shipping_address_subtitle');
    if (result != null) {
      addressChangeNotifier.removeGuestAddress(address.id,
          onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
    }
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
