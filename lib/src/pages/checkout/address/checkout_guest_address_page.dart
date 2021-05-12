import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_country_input.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/components/markaa_text_input_multi.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/pages/my_account/shipping_address/widgets/select_country_dialog.dart';
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
  _CheckoutGuestAddressPageState createState() => _CheckoutGuestAddressPageState();
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
  final LocalStorageRepository localStorageRepository = LocalStorageRepository();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  MarkaaTextInput(
                    controller: firstNameController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'first_name'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: lastNameController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'last_name'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: phoneNumberController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.phone,
                  ),
                  MarkaaTextInput(
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
                  _buildSearchingAddressButton(),
                  MarkaaCountryInput(
                    controller: countryController,
                    countryCode: countryId,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_country_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: () => _onSelectCountry(),
                  ),
                  MarkaaTextInput(
                    controller: stateController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_state_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: () => _onSelectState(),
                  ),
                  MarkaaTextInput(
                    controller: companyController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_company_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: streetController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_street_name_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: postCodeController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_post_code_hint'.tr(),
                    validator: (value) => null,
                    inputType: TextInputType.number,
                  ),
                  MarkaaTextInputMulti(
                    controller: cityController,
                    width: 375.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'checkout_city_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
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

  Widget _buildSearchingAddressButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MarkaaTextIconButton(
        title: 'checkout_searching_address_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(searchAddrIcon),
        onPressed: () => _onSearchAddress(),
        radius: 0,
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
    if (result != null) {
      _updateForm(result as AddressEntity);
    }
  }

  void _updateForm([AddressEntity selectedAddress]) {
    countryController.clear();
    countryId = null;
    stateController.clear();
    cityController.clear();
    streetController.clear();
    postCodeController.clear();
    companyController.clear();
    phoneNumberController.clear();
    countryController.text = selectedAddress?.country;
    countryId = selectedAddress?.countryId;
    stateController.text = selectedAddress?.region;
    cityController.text = selectedAddress?.city;
    streetController.text = selectedAddress?.street;
    postCodeController.text = selectedAddress?.postCode;
    companyController.text = selectedAddress?.company;
    phoneNumberController.text = selectedAddress?.phoneNumber;
    setState(() {});
  }

  void _onSelectCountry() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SelectCountryDialog(value: countryId);
      },
    );
    if (result != null && countryId != result['code']) {
      countryId = result['code'];
      countryController.text = result['name'];
      regionId = '';
      stateController.clear();
      regions = await shippingRepo.getRegions(countryId);
      setState(() {});
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
      String cartId = myCartChangeNotifier.cartId;
      orderDetails['shipping'] = shippingMethodId;
      orderDetails['cartId'] = cartId;
      double totalPrice = .0;
      double subtotalPrice = .0;
      double discount = .0;
      discount = myCartChangeNotifier.type == 'fixed'
          ? myCartChangeNotifier.discount
          : myCartChangeNotifier.discount * myCartChangeNotifier.cartTotalPrice / 100;
      subtotalPrice = myCartChangeNotifier.cartTotalPrice;
      totalPrice = subtotalPrice + serviceFees - discount;
      orderDetails['orderDetails'] = {};
      orderDetails['orderDetails']['discount'] = discount.toStringAsFixed(3);
      orderDetails['orderDetails']['totalPrice'] = totalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['subTotalPrice'] = subtotalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['fees'] = serviceFees.toStringAsFixed(3);
      orderDetails['token'] = '';
      final address = {
        'customer_address_id': '',
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
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
      Navigator.pushNamed(context, Routes.checkoutPayment);
    }
  }
}
