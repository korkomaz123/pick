import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class ProductConfigurableOptions extends StatelessWidget {
  final ProductEntity productEntity;

  ProductConfigurableOptions({this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductChangeNotifier>(builder: (_, model, __) {
      return Container(
        width: 375.w,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: productEntity.configurable.keys.toList().map((key) {
            List<dynamic> options =
                productEntity.configurable[key]['attribute_options'];
            String attributeId =
                productEntity.configurable[key]['attribute_id'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getOptionNameFromKey(key),
                  style: mediumTextStyle.copyWith(
                    fontSize: 20.sp,
                    color: primaryColor,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: options.map((attr) {
                      final isSelected =
                          model.selectedOptions.containsKey(attributeId) &&
                              model.selectedOptions[attributeId] ==
                                  attr['option_value'];
                      return InkWell(
                        onTap: () => model.selectOption(
                          attributeId,
                          attr['option_value'],
                        ),
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
                              color: isSelected
                                  ? Colors.transparent
                                  : greyDarkColor.withOpacity(0.3),
                            ),
                            color: isSelected ? primaryColor : Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            attr['option_label'],
                            style: mediumTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: isSelected ? Colors.white : greyDarkColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }

  String _getOptionNameFromKey(String key) {
    String optionName = '';
    List<String> keyArr = key.split('_');
    for (var item in keyArr) {
      String firstStr = item.substring(0, 1).toUpperCase();
      optionName += '${item.replaceFirst(item.substring(0, 1), firstStr)} ';
    }
    return optionName;
  }
}
