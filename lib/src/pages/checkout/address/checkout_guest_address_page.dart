import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_custom_suffix_input.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_custom_input.dart';
import 'package:markaa/src/components/markaa_custom_input_multi.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/pages/my_account/shipping_address/widgets/select_block_list_dialog.dart';
import 'package:markaa/src/pages/my_account/shipping_address/widgets/select_region_dialog.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:string_validator/string_validator.dart';

class CheckoutGuestAddressPage extends StatefulWidget {
  @override
  _CheckoutGuestAddressPageState createState() =>
      _CheckoutGuestAddressPageState();
}

class _CheckoutGuestAddressPageState extends State<CheckoutGuestAddressPage> {
  String countryId;
  String regionId;
  ProgressService progressService;
  FlushBarService flushBarService;
  final ShippingAddressRepository shippingRepo = ShippingAddressRepository();
  String shippingMethodId;
  double serviceFees;
  MyCartChangeNotifier myCartChangeNotifier;
  final LocalStorageRepository localStorageRepository =
      LocalStorageRepository();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode countryNode = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode streetNode = FocusNode();
  FocusNode postCodeNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode stateNode = FocusNode();
  FocusNode companyNode = FocusNode();

  final CheckoutRepository checkoutRepo = CheckoutRepository();

  _loadData() async {
    shippingMethods = await checkoutRepo.getShippingMethod();
    shippingMethodId = shippingMethods[0].id;
    serviceFees = shippingMethods[0].serviceFees;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    countryId = 'KW';
    countryController.text = 'Kuwait';
    _initForm();
    _loadData();
  }

  void _initForm() async {
    final exist = await localStorageRepository.existItem('guest_address');
    if (exist) {
      final address = await localStorageRepository.getItem('guest_address');
      firstNameController.text = address['firstname'];
      lastNameController.text = address['lastname'];
      fullNameController.text =
          '${address['firstname']} ${address['lastname']}';
      emailController.text = address['email'];
      regionId = address['region_id'];
      stateController.text = address['region'];
      streetController.text = address['street'];
      countryId = address['country_id'];
      countryController.text = address['country'];
      cityController.text = address['city'];
      companyController.text = address['company'];
      postCodeController.text = address['postcode'];
      phoneNumberController.text = address['telephone'];
      setState(() {});
    }
  }

  @override
  void dispose() {
    _onRetrieveRegions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildEditFormView(),
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

  Widget _buildEditFormView() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  MarkaaCustomInput(
                    controller: fullNameController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'full_name'.tr(),
                    validator: (value) => value.isEmpty
                        ? 'required_field'.tr()
                        : (value.trim().indexOf(' ') == -1
                            ? 'full_name_issue'.tr()
                            : null),
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomInput(
                    controller: phoneNumberController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomInput(
                    controller: emailController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'email'.tr(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'required_field'.tr();
                      } else if (!isEmail(value)) {
                        return 'invalid_field'.tr();
                      }
                      return null;
                    },
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomInput(
                    controller: stateController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_state_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: _onSelectState,
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomInput(
                    controller: companyController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_company_hint'.tr(),
                    validator: (value) => value.isEmpty
                        ? 'required_field'.tr()
                        : !isInt(value)
                            ? 'invalid_field'.tr()
                            : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: _onSelectBlock,
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomSuffixInput(
                    controller: streetController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_street_name_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    suffixIcon: IconButton(
                      onPressed: _onSearchAddress,
                      icon: SvgPicture.asset(searchAddrIcon),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  MarkaaCustomInputMulti(
                    controller: cityController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_city_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    maxLine: 3,
                  ),
                ],
              ),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
      child: MaterialButton(
        onPressed: () => _onContinue(),
        color: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'checkout_continue_payment_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  void _onSearchAddress() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.searchAddress,
    );
    FocusScope.of(context).requestFocus(FocusNode());
    if (result != null) {
      final address = result as AddressEntity;
      streetController.text = address?.street ?? '';
    }
  }

  void _onSelectBlock() async {
    final result = await showDialog(
      context: context,
      builder: (_) {
        return SelectBlockListDialog(value: companyController.text);
      },
    );
    if (result != null) {
      companyController.text = result.toString();
    }
  }

  void _onSelectState() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SelectRegionDialog(value: regionId);
      },
    );
    if (result != null) {
      RegionEntity selectedRegion = result as RegionEntity;
      regionId = selectedRegion.regionId;
      stateController.text = selectedRegion.defaultName;
      setState(() {});
    }
  }

  void _onRetrieveRegions() async {
    regions = await shippingRepo.getRegions();
  }

  void _onContinue() async {
    if (formKey.currentState.validate()) {
      String firstName = fullNameController.text.split(' ')[0];
      String lastName = fullNameController.text.split(' ')[1];

      String cartId = myCartChangeNotifier.cartId;
      orderDetails['shipping'] = shippingMethodId;
      orderDetails['cartId'] = cartId;
      double totalPrice = .0;
      double subtotalPrice = .0;
      double discount = .0;
      discount = myCartChangeNotifier.type == 'fixed'
          ? myCartChangeNotifier.discount
          : myCartChangeNotifier.discount *
              myCartChangeNotifier.cartTotalPrice /
              100;
      subtotalPrice = myCartChangeNotifier.cartTotalPrice;
      totalPrice = subtotalPrice + serviceFees - discount;
      orderDetails['orderDetails'] = {};
      orderDetails['orderDetails']['discount'] = discount.toStringAsFixed(3);
      orderDetails['orderDetails']['totalPrice'] =
          totalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['subTotalPrice'] =
          subtotalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['fees'] = serviceFees.toStringAsFixed(3);
      orderDetails['token'] = '';
      final address = {
        'customer_address_id': '',
        'firstname': firstName,
        'lastname': lastName,
        'email': emailController.text,
        'region_id': regionId,
        'region': stateController.text,
        'street': streetController.text,
        'country_id': countryId,
        'country': countryController.text,
        'city': cityController.text,
        'company': companyController.text,
        'postcode': postCodeController.text,
        'telephone': phoneNumberController.text,
        'save_in_address_book': '0',
        'prefix': '',
      };
      localStorageRepository.setItem('guest_address', address);
      orderDetails['orderAddress'] = jsonEncode(address);

      AdjustEvent adjustEvent =
          new AdjustEvent(AdjustSDKConfig.initiateCheckout);
      Adjust.trackEvent(adjustEvent);

      Navigator.pushNamed(context, Routes.checkoutPayment);
    }
  }
}
