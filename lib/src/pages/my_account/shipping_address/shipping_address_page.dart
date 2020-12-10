import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:ciga/src/pages/product_list/widgets/product_no_available.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  String defaultAddressId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  ShippingAddressBloc shippingAddressBloc;
  List<AddressEntity> shippingAddresses = [];
  int selectedIndex;
  bool isCheckout = false;

  @override
  void initState() {
    super.initState();
    isCheckout = widget.isCheckout != null ? widget.isCheckout : false;
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    flushBarService = FlushBarService(context: context);
    shippingAddressBloc = context.read<ShippingAddressBloc>();
    shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
  }

  void _onRefresh() async {
    shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    shippingAddressBloc.add(ShippingAddressInitialized());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
        isCenter: false,
      ),
      body: Column(
        children: [
          _buildAppBar(),
          _buildAddressList(),
          SizedBox(height: pageStyle.unitHeight * 60),
        ],
      ),
      bottomSheet: Container(
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
      ),
      bottomNavigationBar: CigaBottomBar(
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
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () => null,
        child: BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
          listener: (context, state) {
            if (state is ShippingAddressLoadedFailure) {
              flushBarService.showErrorMessage(pageStyle, state.message);
            }
            if (state is ShippingAddressRemovedInProcess) {
              progressService.showProgress();
            }
            if (state is ShippingAddressRemovedFailure) {
              progressService.hideProgress();
              flushBarService.showErrorMessage(pageStyle, state.message);
            }
            if (state is ShippingAddressRemovedSuccess) {
              progressService.hideProgress();
              flushBarService.showInformMessage(pageStyle, 'removed'.tr());
              shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
            }
            if (state is DefaultShippingAddressUpdatedInProcess) {
              progressService.showProgress();
            }
            if (state is DefaultShippingAddressUpdatedFailure) {
              progressService.hideProgress();
              flushBarService.showErrorMessage(pageStyle, state.message);
            }
            if (state is DefaultShippingAddressUpdatedSuccess) {
              progressService.hideProgress();
              if (isCheckout) {
                Navigator.pop(context, addresses[selectedIndex]);
              } else {
                shippingAddressBloc
                    .add(ShippingAddressLoaded(token: user.token));
              }
            }
          },
          builder: (context, state) {
            if (state is ShippingAddressLoadedSuccess) {
              addresses = state.addresses;
              shippingAddresses = state.addresses;
              for (int i = 0; i < shippingAddresses.length; i++) {
                if (shippingAddresses[i].defaultShippingAddress == 1) {
                  defaultAddressId = shippingAddresses[i].addressId;
                  defaultAddress = shippingAddresses[i];
                }
              }
            }
            return state is ShippingAddressLoadedSuccess &&
                    shippingAddresses.isEmpty
                ? ProductNoAvailable(pageStyle: pageStyle)
                : SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        shippingAddresses.length,
                        (index) => _buildAddressCard(index),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildAddressCard(int index) {
    return InkWell(
      onTap: () => _onUpdate(index),
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 190,
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
                      addresses[index].title,
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: pageStyle.unitFontSize * 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      addresses[index].country,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      addresses[index].city,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      addresses[index].street,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    SizedBox(height: pageStyle.unitHeight * 6),
                    Text(
                      'phone_number_hint'.tr() +
                          ': ' +
                          addresses[index].phoneNumber,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Radio(
                value: addresses[index].addressId,
                groupValue: defaultAddressId,
                activeColor: primaryColor,
                onChanged: (value) {
                  defaultAddressId = value;
                  _onUpdate(index);
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: SvgPicture.asset(editIcon),
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.editAddress,
                  arguments: addresses[index],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: SvgPicture.asset(trashIcon),
                onPressed: () => _onRemove(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRemove(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return ShippingAddressRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      shippingAddressBloc.add(ShippingAddressRemoved(
        addressId: addresses[index].addressId,
        token: user.token,
      ));
    }
  }

  void _onUpdate(int index) async {
    selectedIndex = index;
    defaultAddress = shippingAddresses[index];
    shippingAddressBloc.add(DefaultShippingAddressUpdated(
      token: user.token,
      title: addresses[index].title,
      addressId: addresses[index].addressId,
      firstName: addresses[index].firstName,
      lastName: addresses[index].lastName,
      countryId: addresses[index].countryId,
      region: addresses[index].region,
      city: addresses[index].city,
      streetName: addresses[index].street,
      zipCode: addresses[index].zipCode,
      phone: addresses[index].phoneNumber,
      isDefaultBilling: addresses[index].defaultBillingAddress.toString(),
      isDefaultShipping: '1',
    ));
  }
}
