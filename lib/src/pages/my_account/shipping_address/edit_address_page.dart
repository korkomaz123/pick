import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_country_input.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:string_validator/string_validator.dart';

import 'bloc/shipping_address_bloc.dart';
import 'bloc/shipping_address_repository.dart';
import 'widgets/select_country_dialog.dart';
import 'widgets/select_region_dialog.dart';

class EditAddressPage extends StatefulWidget {
  final AddressEntity address;

  EditAddressPage({this.address});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool isNew;
  String countryId;
  String regionId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  ShippingAddressBloc shippingAddressBloc;
  ShippingAddressRepository shippingRepo;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isNew = true;
    firstNameController.text = user?.firstName;
    lastNameController.text = user?.lastName;
    emailController.text = user?.email;
    if (widget.address != null) {
      isNew = false;
      firstNameController.text = widget?.address?.firstName;
      lastNameController.text = widget?.address?.lastName;
      emailController.text = widget?.address?.email;
      titleController.text = widget?.address?.title;
      countryController.text = widget?.address?.country;
      countryId = widget?.address?.countryId;
      stateController.text = widget?.address?.region;
      regionId = widget?.address?.region;
      cityController.text = widget?.address?.city;
      companyController.text = widget?.address?.company;
      streetController.text = widget?.address?.street;
      zipCodeController.text = widget?.address?.zipCode;
      phoneNumberController.text = widget?.address?.phoneNumber;
    } else {
      countryId = 'KW';
      countryController.text = 'Kuwait';
    }
    shippingAddressBloc = context.read<ShippingAddressBloc>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    flushBarService = FlushBarService(context: context);
    shippingRepo = context.read<ShippingAddressRepository>();
  }

  void _onSuccess() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _onRetrieveRegions();
    shippingAddressBloc.add(ShippingAddressInitialized());
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
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: BlocListener<ShippingAddressBloc, ShippingAddressState>(
        listener: (context, state) {
          if (state is ShippingAddressAddedInProcess) {
            print('process');
            progressService.showProgress();
          }
          if (state is ShippingAddressAddedSuccess) {
            print('success');
            progressService.hideProgress();
            _onSuccess();
          }
          if (state is ShippingAddressAddedFailure) {
            print('failure');
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
          if (state is ShippingAddressUpdatedInProcess) {
            progressService.showProgress();
          }
          if (state is ShippingAddressUpdatedSuccess) {
            print('updated success');
            progressService.hideProgress();
            _onSuccess();
          }
          if (state is ShippingAddressUpdatedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        child: Column(
          children: [
            _buildAppBar(),
            _buildEditFormView(),
          ],
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
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: firstNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'first_name'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                  ),
                  MarkaaTextInput(
                    controller: lastNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'last_name'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                  ),
                  MarkaaTextInput(
                    controller: phoneNumberController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.phone,
                  ),
                  MarkaaTextInput(
                    controller: emailController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'email'.tr(),
                    readOnly: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'required_field'.tr();
                      } else if (!isEmail(value)) {
                        return 'invalid_field'.tr();
                      }
                      return null;
                    },
                    inputType: TextInputType.phone,
                  ),
                  MarkaaCountryInput(
                    controller: countryController,
                    countryCode: countryId,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_country_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
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
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
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
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: streetController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_street_name_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: cityController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_city_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  MarkaaTextInput(
                    controller: zipCodeController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_zip_code_hint'.tr(),
                    validator: (value) => null,
                    inputType: TextInputType.number,
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
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
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
          'save_address_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 16,
          ),
        ),
      ),
    );
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
      regions = await shippingRepo.getRegions(lang, countryId);
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
      if (isNew) {
        shippingAddressBloc.add(ShippingAddressAdded(
          token: user.token,
          title: titleController.text,
          countryId: countryId,
          region: regionId,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          city: cityController.text,
          streetName: streetController.text,
          zipCode: zipCodeController.text,
          phone: phoneNumberController.text,
          company: companyController.text,
          email: emailController.text,
        ));
      } else {
        shippingAddressBloc.add(ShippingAddressUpdated(
          token: user.token,
          addressId: widget.address.addressId,
          title: titleController.text,
          countryId: countryId,
          region: regionId,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          city: cityController.text,
          streetName: streetController.text,
          zipCode: zipCodeController.text,
          phone: phoneNumberController.text,
          company: companyController.text,
          email: emailController.text,
        ));
      }
    }
  }
}
