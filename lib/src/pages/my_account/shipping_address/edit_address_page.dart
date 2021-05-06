import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_country_input.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/components/markaa_text_input_multi.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:string_validator/string_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/select_country_dialog.dart';
import 'widgets/select_region_dialog.dart';

class EditAddressPage extends StatefulWidget {
  final Map<String, dynamic> params;

  EditAddressPage({this.params});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool isNew;
  String countryId;
  String regionId;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  final ShippingAddressRepository shippingRepo = ShippingAddressRepository();
  AddressChangeNotifier model;
  AddressEntity addressParam;
  bool isCheckout;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = context.read<AddressChangeNotifier>();
    isCheckout = false;
    if (widget.params != null) {
      if (widget.params.containsKey('address')) {
        addressParam = widget.params['address'];
      }
      if (widget.params.containsKey('isCheckout')) {
        isCheckout = widget.params['isCheckout'];
      }
    }
    isNew = true;
    firstNameController.text = user?.firstName;
    lastNameController.text = user?.lastName;
    emailController.text = user?.email;
    if (addressParam != null) {
      isNew = false;
      firstNameController.text = addressParam?.firstName;
      lastNameController.text = addressParam?.lastName;
      emailController.text = addressParam?.email;
      titleController.text = addressParam?.title;
      countryController.text = addressParam?.country;
      countryId = addressParam?.countryId;
      stateController.text = addressParam?.region;
      regionId = addressParam?.region;
      cityController.text = addressParam?.city;
      companyController.text = addressParam?.company;
      streetController.text = addressParam?.street;
      postCodeController.text = addressParam?.postCode;
      phoneNumberController.text = addressParam?.phoneNumber;
    } else {
      countryId = 'KW';
      countryController.text = 'Kuwait';
    }
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  void dispose() {
    _onRetrieveRegions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
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
                    controller: titleController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'address_title'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: firstNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'first_name'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: lastNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'last_name'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: phoneNumberController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.phone,
                  ),
                  MarkaaTextInput(
                    controller: emailController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
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
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_country_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: () => _onSelectCountry(),
                    pageStyle: pageStyle,
                  ),
                  MarkaaTextInput(
                    controller: stateController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_state_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: () => _onSelectState(),
                  ),
                  MarkaaTextInput(
                    controller: companyController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_company_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: streetController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_street_name_hint'.tr(),
                    validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: postCodeController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_post_code_hint'.tr(),
                    validator: (value) => null,
                    inputType: TextInputType.number,
                  ),
                  MarkaaTextInputMulti(
                    controller: cityController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
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
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
      ),
      child: MarkaaTextIconButton(
        title: 'checkout_searching_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
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
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 30,
      ),
      child: MaterialButton(
        onPressed: () => _onSave(),
        color: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'checkout_save_address_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 16,
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
      _initForm(result as AddressEntity);
    }
  }

  void _initForm([AddressEntity selectedAddress]) {
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
        return SelectCountryDialog(pageStyle: pageStyle, value: countryId);
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
        return SelectRegionDialog(pageStyle: pageStyle, value: regionId);
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
    regions = await shippingRepo.getRegions(lang);
  }

  void _onSave() async {
    if (formKey.currentState.validate()) {
      AddressEntity address = AddressEntity(
        title: titleController.text,
        country: countryController.text,
        countryId: countryId,
        regionId: regionId,
        region: stateController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        city: cityController.text.trim(),
        street: streetController.text,
        postCode: postCodeController.text,
        phoneNumber: phoneNumberController.text,
        company: companyController.text,
        email: emailController.text,
        defaultBillingAddress: addressParam?.defaultBillingAddress != null
            ? addressParam?.defaultBillingAddress
            : isCheckout
                ? 1
                : 0,
        defaultShippingAddress: addressParam?.defaultShippingAddress != null
            ? addressParam?.defaultShippingAddress
            : isCheckout
                ? 1
                : 0,
        addressId: addressParam?.addressId ?? '',
      );
      if (isNew) {
        await model.addAddress(user.token, address, _onProcess, _onSuccess, _onFailure);
      } else {
        await model.updateAddress(user.token, address, _onProcess, _onSuccess, _onFailure);
      }
    }
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onSuccess() {
    progressService.hideProgress();
    if (isCheckout) {
      Navigator.popUntil(
        context,
        (route) => route.settings.name == Routes.checkoutAddress,
      );
    } else {
      Navigator.popUntil(
        context,
        (route) => route.settings.name == Routes.shippingAddress,
      );
    }
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorMessage(pageStyle, error);
  }
}
