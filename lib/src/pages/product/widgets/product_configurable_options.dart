import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class ProductConfigurableOptions extends StatelessWidget {
  final ProductEntity productEntity;
  final ProductChangeNotifier model;

  ProductConfigurableOptions({this.productEntity, this.model});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = model.selectedOptions.isEmpty || model.selectedVariant != null;
    return Container(
      width: 375.w,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isAvailable) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Text(
                'not_available'.tr(),
                style: mediumTextStyle.copyWith(
                  color: dangerColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
          if (productEntity?.configurable?.keys != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productEntity.configurable.keys.toList().map((key) {
                List<dynamic> options = productEntity.configurable[key]['attribute_options'];
                String attributeId = productEntity.configurable[key]['attribute_id'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productEntity.configurable[key]['attribute_name'],
                      style: mediumTextStyle.copyWith(
                        fontSize: 20.sp,
                        color: primaryColor,
                      ),
                    ),
                    if (key == 'color') ...[
                      _buildColorOptions(options, attributeId, model),
                    ] else ...[
                      _buildOptions(options, attributeId, model),
                    ]
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptions(
    List<dynamic> options,
    String attributeId,
    ProductChangeNotifier model,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((attr) {
          bool isAvaliable = false;
          if (model.selectedOptions.containsKey(productEntity.configurable['color']['attribute_id'])) {
            List<ProductModel> _find =
                productEntity.variants.where((e) => e.sku == "${productEntity.sku}-${model.currentColor}-${attr['option_label']}").toList();
            isAvaliable = _find.length > 0;
          } else {
            isAvaliable = true;
          }
          final isSelected = model.selectedOptions.containsKey(attributeId) && model.selectedOptions[attributeId] == attr['option_value'];
          return InkWell(
            onTap: () {
              if (isAvaliable) {
                model.changeCurrentSize(isSelected ? "" : attr['option_label']);
                model.selectOption(
                  attributeId,
                  attr['option_value'],
                  !isSelected,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 5.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : greyDarkColor.withOpacity(0.3),
                ),
                color: isSelected ? primaryColor : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                attr['option_label'],
                style: mediumTextStyle.copyWith(
                    fontSize: 14.sp, color: isSelected ? Colors.white : greyDarkColor, decoration: isAvaliable ? null : TextDecoration.lineThrough),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColorOptions(
    List<dynamic> options,
    String attributeId,
    ProductChangeNotifier model,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((attr) {
          bool isAvaliable = false;
          if (model.selectedOptions.containsKey(productEntity.configurable['size']['attribute_id'])) {
            List<ProductModel> _find =
                productEntity.variants.where((e) => e.sku == "${productEntity.sku}-${attr['option_label']}-${model.currentSize}").toList();
            isAvaliable = _find.length > 0;
          } else {
            isAvaliable = true;
          }
          final isSelected = model.selectedOptions.containsKey(attributeId) && model.selectedOptions[attributeId] == attr['option_value'];
          Color optionColor = attr['color_value'] == null ? Colors.black : HexColor(attr['color_value']);
          return InkWell(
            onTap: () {
              if (isAvaliable) {
                model.changeCurrentColor(isSelected ? "" : attr['option_label']);
                model.selectOption(
                  attributeId,
                  attr['option_value'],
                  !isSelected,
                );
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w),
              ),
              child: Center(
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? optionColor : Colors.white,
                    border: Border.all(color: optionColor, width: 4.w),
                  ),
                  alignment: Alignment.center,
                  child: isAvaliable
                      ? null
                      : Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.blue,
                          ),
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
