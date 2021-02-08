import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String defaultAddressId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  ShippingAddressBloc shippingAddressBloc;
  List<AddressEntity> shippingAddresses;
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

  void _onSuccess() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.shippingAddress,
    );
    shippingAddressBloc.add(ShippingAddressInitialized());
    Future.delayed(Duration(milliseconds: 500), () {
      shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
    });
  }

  // void _moveToActiveItem() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       Scrollable.ensureVisible(dataKey.currentContext);
  //     });
  //   });
  // }

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
          onPressed: () async {
            Navigator.pushNamed(context, Routes.editAddress);
            shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
          },
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
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () => null,
        child: BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
          listener: (context, state) {
            // if (state is ShippingAddressLoadedSuccess) {
            //   _moveToActiveItem();
            // }
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
            if (state is ShippingAddressAddedSuccess) {
              _onSuccess();
            }
            if (state is ShippingAddressUpdatedSuccess) {
              _onSuccess();
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
            if (shippingAddresses == null) {
              return Center(
                child: PulseLoadingSpinner(),
              );
            }
            if (shippingAddresses.isEmpty) {
              return Center(
                child: NoAvailableData(
                  pageStyle: pageStyle,
                  message: 'no_saved_addresses'.tr(),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  shippingAddresses.length,
                  (index) {
                    int i = shippingAddresses.length - index - 1;
                    return _buildAddressCard(i);
                  },
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
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.editAddress,
                    arguments: addresses[index],
                  );
                  shippingAddressBloc
                      .add(ShippingAddressLoaded(token: user.token));
                },
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
      company: addresses[index].company,
      isDefaultBilling: addresses[index].defaultBillingAddress.toString(),
      isDefaultShipping: '1',
    ));
  }
}
