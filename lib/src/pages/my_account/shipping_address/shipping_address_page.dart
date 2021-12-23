import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShippingAddressPage extends StatefulWidget {
  final bool isCheckout;

  ShippingAddressPage({this.isCheckout = false});

  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final dataKey = GlobalKey();

  final _refreshController = RefreshController(initialRefresh: false);

  ProgressService? progressService;
  FlushBarService? flushBarService;

  List<AddressEntity>? shippingAddresses;
  int? selectedIndex;
  bool isCheckout = false;

  late AddressChangeNotifier model;

  @override
  void initState() {
    super.initState();
    isCheckout = widget.isCheckout;

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    model = context.read<AddressChangeNotifier>();
  }

  void _onRefresh() async {
    model.initialize();
    await model.loadCustomerAddresses(
      user!.token,
      _refreshController.refreshCompleted,
      _refreshController.refreshFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildAddressList(),
        ],
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
        'shipping_address_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return Expanded(
      child: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: MaterialClassicHeader(color: primaryColor),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: () => null,
            child: Consumer<AddressChangeNotifier>(
              builder: (_, notifier, ___) {
                model = notifier;
                if (model.customerAddressKeys.isEmpty) {
                  return NoAvailableData(
                    message: 'no_saved_addresses'.tr(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        model.customerAddressKeys.length,
                        (index) => _buildAddressCard(model.customerAddressKeys[index]),
                      )..add(SizedBox(height: 60.h)),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildAddNewButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      child: MaterialButton(
        onPressed: () => Navigator.pushNamed(context, Routes.editAddress),
        color: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'add_new_address_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(String key) {
    final address = model.customerAddressesMap[key];
    return InkWell(
      onTap: () => _onUpdate(key),
      child: Container(
        width: 375.w,
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 15.h,
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address?.fullName?.toUpperCase() ?? '',
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      address?.street ?? '',
                      style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 14.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${address?.city ?? ''}, ${address?.country ?? ''}',
                      style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 14.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'phone_number_hint'.tr() + ': ' + (address?.phoneNumber ?? ''),
                      style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Radio(
                value: address?.addressId ?? '',
                groupValue: model.customerDefaultAddress?.addressId ?? '',
                activeColor: primaryColor,
                onChanged: _onUpdate,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(editIcon),
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.editAddress,
                  arguments: {'address': address},
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(trashIcon),
                onPressed: () => _onRemove(key),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRemove(String key) async {
    final result = await flushBarService!.showConfirmDialog(message: 'remove_shipping_address_subtitle');
    if (result != null) {
      await model.deleteCustomerAddress(user!.token, key, _onProcess, _onSuccess, _onFailure);
    }
  }

  void _onUpdate(String? key) async {
    final address = model.customerAddressesMap[key];
    address!.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    await model.updateCustomerAddress(user!.token, address,
        onProcess: _onProcess, onSuccess: _onUpdateSuccess, onFailure: _onFailure);
  }

  void _onProcess() {
    progressService!.showProgress();
  }

  void _onSuccess() {
    progressService!.hideProgress();
  }

  void _onUpdateSuccess() {
    progressService!.hideProgress();
    if (isCheckout) {
      Navigator.pop(context);
    }
  }

  void _onFailure(String error) {
    progressService!.hideProgress();
    flushBarService!.showErrorDialog(error);
  }
}
