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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_validator/string_validator.dart';

import 'widgets/select_region_dialog.dart';
import 'widgets/select_block_list_dialog.dart';

class EditAddressPage extends StatefulWidget {
  final Map<String, dynamic> params;

  EditAddressPage({this.params});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool isNew;
  bool isCheckout;

  String countryId;
  String regionId;

  ProgressService progressService;
  FlushBarService flushBarService;

  ShippingAddressRepository shippingRepo = ShippingAddressRepository();

  AddressChangeNotifier model;
  AddressEntity addressParam;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
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
    fullNameController.text =
        firstNameController.text + " " + lastNameController.text;
    emailController.text = user?.email;
    if (addressParam != null) {
      isNew = false;
      firstNameController.text = addressParam?.firstName;
      lastNameController.text = addressParam?.lastName;
      fullNameController.text =
          firstNameController.text + " " + lastNameController.text;
      emailController.text = addressParam?.email;
      titleController.text = addressParam?.title ?? 'title';
      countryController.text = addressParam?.country;
      countryId = addressParam?.countryId;
      stateController.text = addressParam?.region;
      regionId = addressParam?.regionId;
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
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          AppBar(
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
          ),
          _buildEditFormView(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.account,
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
                  SizedBox(height: 10.h),
                  MarkaaCustomInput(
                    controller: fullNameController,
                    width: designWidth.w,
                    padding: 10.w,
                    fontSize: 14.sp,
                    hint: 'full_name'.tr(),
                    validator: (String value) => value.isEmpty
                        ? 'required_field'.tr()
                        : (value.trim().indexOf(' ') == -1
                            ? 'full_name_issue'.tr()
                            : null),
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10.h),
                  MarkaaCustomInput(
                    controller: phoneNumberController,
                    width: 375.w,
                    padding: 10.h,
                    fontSize: 14.sp,
                    hint: 'phone_number_hint'.tr(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'required_field'.tr();
                      } else if (!isLength(value, 8, 9)) {
                        return 'invalid_length_phone_number'.tr();
                      }
                      return null;
                    },
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 10.h),
                  MarkaaCustomInput(
                    controller: stateController,
                    width: 375.w,
                    padding: 10.h,
                    fontSize: 14.sp,
                    hint: 'checkout_state_hint'.tr(),
                    validator: (value) =>
                        value.isEmpty ? 'required_field'.tr() : null,
                    inputType: TextInputType.text,
                    readOnly: true,
                    onTap: _onSelectState,
                  ),
                  SizedBox(height: 10.h),
                  MarkaaCustomInput(
                    controller: companyController,
                    width: 375.w,
                    padding: 10.h,
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
                  SizedBox(height: 10.h),
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
                  SizedBox(height: 10.h),
                  MarkaaCustomInputMulti(
                    controller: cityController,
                    width: 375.w,
                    padding: 10.h,
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
      margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 30.h),
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
      streetController.text = address.street ?? '';
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

  void _onRetrieveRegions() async {
    regions = await shippingRepo.getRegions(lang);
  }

  void _onSave() async {
    if (formKey.currentState.validate()) {
      String firstName = fullNameController.text.split(' ')[0];
      String lastName = fullNameController.text.split(' ')[1];

      AddressEntity address = AddressEntity(
        title: 'title',
        country: countryController.text,
        countryId: countryId,
        regionId: regionId,
        region: stateController.text,
        firstName: firstName,
        fullName: fullNameController.text,
        lastName: lastName,
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
      if (user?.token != null) {
        if (isNew) {
          await model.addAddress(user.token, address,
              onProcess: _onProcess,
              onSuccess: _onSuccess,
              onFailure: _onFailure);
        } else {
          await model.updateAddress(user.token, address,
              onProcess: _onProcess,
              onSuccess: _onSuccess,
              onFailure: _onFailure);
        }
      } else {
        await model.updateGuestAddress(address.toJson());
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
        (route) => route.settings.name == Routes.checkout,
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
    flushBarService.showErrorDialog(error);
  }
}
