import 'dart:io';
import 'dart:typed_data';

import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/image_custom_picker_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelOrderInfoPage extends StatefulWidget {
  final Map<String, dynamic> params;

  CancelOrderInfoPage({required this.params});

  @override
  _CancelOrderInfoPageState createState() => _CancelOrderInfoPageState();
}

class _CancelOrderInfoPageState extends State<CancelOrderInfoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController additionalInfoController = TextEditingController();
  ImageCustomPickerService? imageCustomPickerService;
  FlushBarService? flushBarService;
  ProgressService? progressService;
  OrderEntity? order;
  Map<String, dynamic> cancelledItemsMap = {};
  File? file;
  Uint8List? imageData;
  String? name;
  OrderChangeNotifier? orderChangeNotifier;

  @override
  void initState() {
    super.initState();
    order = widget.params['order'];
    cancelledItemsMap = widget.params['items'];

    orderChangeNotifier = context.read<OrderChangeNotifier>();

    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);

    imageCustomPickerService = ImageCustomPickerService(
      context: context,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      video: false,
    );
  }

  void _onCancelProcess() {
    progressService!.showProgress();
  }

  void _onCanceledSuccess() {
    progressService!.hideProgress();
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.orderHistory,
    );
  }

  void _onCanceledFailure(String error) {
    progressService!.hideProgress();
    flushBarService!.showErrorDialog(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: SecondaryAppBar(title: 'cancel_order_button_title'.tr()),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [_buildAdditionalInfo(), _buildImageUploader(), _buildSubmitButton()],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.h),
      child: MarkaaInputField(
        width: double.infinity,
        controller: additionalInfoController,
        space: 4.h,
        radius: 10.sp,
        fontSize: 16.sp,
        fontColor: greyDarkColor,
        label: 'cancel_order_additional_info_title'.tr(),
        labelColor: greyDarkColor,
        labelSize: 16.sp,
        fillColor: Colors.white,
        bordered: true,
        borderColor: Colors.grey,
        maxLines: 5,
        validator: (value) => value!.isEmpty ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildImageUploader() {
    return Container(
      width: 375.w,
      height: 120.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: file != null
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: FileImage(file!),
                fit: BoxFit.cover,
              ),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: Colors.grey),
            ),
      child: file != null
          ? Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: primaryColor,
                  size: 30.sp,
                ),
                onPressed: () => _onChangeImage(),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: primaryColor,
                    size: 30.sp,
                  ),
                  onPressed: () => _onChangeImage(),
                ),
                Text(
                  'cancel_order_image_for_product_title'.tr(),
                  style: mediumTextStyle.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: MaterialButton(
        onPressed: () => _onSubmit(),
        minWidth: 150.w,
        height: 45.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: primaryColor,
        child: Text(
          'submit_button_title'.tr(),
          style: mediumTextStyle.copyWith(fontSize: 17.sp, color: Colors.white),
        ),
      ),
    );
  }

  void _onChangeImage() async {
    File? imageFile = await imageCustomPickerService!.getImageWithDialog();
    if (imageFile != null) {
      file = imageFile;
      name = file!.path.split('/').last;
      imageData = file!.readAsBytesSync();
      setState(() {});
    }
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      List<Map<String, dynamic>> items = [];
      List<String> keys = cancelledItemsMap.keys.toList();
      items = keys.map((key) {
        return {
          'productId': int.parse(key),
          'cancelCount': cancelledItemsMap[key],
        };
      }).toList();
      orderChangeNotifier!.cancelOrder(
        order!.orderId,
        items,
        additionalInfoController.text,
        additionalInfoController.text,
        imageData!,
        name!,
        onProcess: _onCancelProcess,
        onSuccess: _onCanceledSuccess,
        onFailure: _onCanceledFailure,
      );
    }
  }
}
