import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
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
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widgets/shipping_address_remove_dialog.dart';

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
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  List<AddressEntity> shippingAddresses;
  int selectedIndex;
  bool isCheckout = false;
  int length;
  AddressChangeNotifier model;

  @override
  void initState() {
    super.initState();
    isCheckout = widget?.isCheckout != null ? widget.isCheckout : false;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    model = context.read<AddressChangeNotifier>();
  }

  void _onRefresh() async {
    model.initialize();
    await model.loadAddresses(
      user.token,
      () => _refreshController.refreshCompleted(),
      () => _refreshController.refreshFailed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildAddressList(),
        ],
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
        'shipping_address_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
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
                if (model.keys.isEmpty) {
                  return NoAvailableData(
                    pageStyle: pageStyle,
                    message: 'no_saved_addresses'.tr(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        model.keys.length,
                        (index) => _buildAddressCard(model.keys[index]),
                      )..add(SizedBox(height: pageStyle.unitHeight * 60)),
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
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 5,
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
            fontSize: pageStyle.unitFontSize * 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(String key) {
    final address = model.addressesMap[key];
    return InkWell(
      onTap: () => _onUpdate(key),
      child: Container(
        width: pageStyle.deviceWidth,
        margin: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 10,
          vertical: pageStyle.unitHeight * 15,
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
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 60,
                  vertical: pageStyle.unitHeight * 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.title,
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: pageStyle.unitFontSize * 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      address.country,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      address.city,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      address.street,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      'phone_number_hint'.tr() + ': ' + address.phoneNumber,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
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
                groupValue: model?.defaultAddress?.addressId ?? '',
                activeColor: primaryColor,
                onChanged: (value) => _onUpdate(value),
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
    final result = await showDialog(
      context: context,
      builder: (context) {
        return ShippingAddressRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      await model.deleteAddress(
          user.token, key, _onProcess, _onSuccess, _onFailure);
    }
  }

  void _onUpdate(String key) async {
    final address = model.addressesMap[key];
    address.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    await model.updateAddress(
        user.token, address, _onProcess, _onUpdateSuccess, _onFailure);
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onSuccess() {
    progressService.hideProgress();
  }

  void _onUpdateSuccess() {
    progressService.hideProgress();
    if (isCheckout) {
      Navigator.pop(context);
    }
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorMessage(pageStyle, error);
  }
}
