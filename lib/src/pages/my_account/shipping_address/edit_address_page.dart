import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/ciga_text_input.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'bloc/shipping_address_bloc.dart';
import 'widgets/select_country_dialog.dart';

class EditAddressPage extends StatefulWidget {
  final AddressEntity address;

  EditAddressPage({this.address});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool isNew;
  String countryId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  ShippingAddressBloc shippingAddressBloc;

  @override
  void initState() {
    super.initState();
    isNew = true;
    firstNameController.text = user?.firstName;
    lastNameController.text = user?.lastName;
    if (widget.address != null) {
      isNew = false;
      firstNameController.text = widget?.address?.firstName;
      lastNameController.text = widget?.address?.lastName;
      countryController.text = widget?.address?.country;
      cityController.text = widget?.address?.city;
      streetController.text = widget?.address?.street;
      zipCodeController.text = widget?.address?.zipCode;
      phoneNumberController.text = widget?.address?.phoneNumber;
      countryId = widget?.address?.countryId;
    }
    shippingAddressBloc = context.bloc<ShippingAddressBloc>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: BlocListener<ShippingAddressBloc, ShippingAddressState>(
        listener: (context, state) {
          if (state is ShippingAddressAddedInProcess) {
            progressService.showProgress();
          }
          if (state is ShippingAddressAddedSuccess) {
            progressService.hideProgress();
            Navigator.pop(context);
          }
          if (state is ShippingAddressAddedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
          if (state is ShippingAddressUpdatedInProcess) {
            progressService.showProgress();
          }
          if (state is ShippingAddressUpdatedSuccess) {
            progressService.hideProgress();
            Navigator.pop(context);
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
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'shipping_address_title'.tr(),
        style: boldTextStyle.copyWith(
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
                  CigaTextInput(
                    controller: firstNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'firstName'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  CigaTextInput(
                    controller: lastNameController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'lastName'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  CigaTextInput(
                    controller: countryController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'country'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: () => _onSelectCountry(),
                  ),
                  CigaTextInput(
                    controller: cityController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'city'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  CigaTextInput(
                    controller: streetController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_street_name_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                  ),
                  CigaTextInput(
                    controller: zipCodeController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'checkout_zip_code_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.number,
                  ),
                  CigaTextInput(
                    controller: phoneNumberController,
                    width: pageStyle.deviceWidth,
                    padding: pageStyle.unitWidth * 10,
                    fontSize: pageStyle.unitFontSize * 14,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.phone,
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
    if (result != null) {
      countryId = result['code'];
      countryController.text = result['name'];
    }
  }

  void _onSave() async {
    if (formKey.currentState.validate()) {
      if (isNew) {
        shippingAddressBloc.add(ShippingAddressAdded(
          token: user.token,
          countryId: countryId,
          region: '',
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          city: cityController.text,
          streetName: streetController.text,
          zipCode: zipCodeController.text,
          phone: phoneNumberController.text,
        ));
      } else {
        shippingAddressBloc.add(ShippingAddressUpdated(
          token: user.token,
          addressId: widget.address.addressId,
          countryId: countryId,
          region: '',
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          city: cityController.text,
          streetName: streetController.text,
          zipCode: zipCodeController.text,
          phone: phoneNumberController.text,
        ));
      }
    }
  }
}
