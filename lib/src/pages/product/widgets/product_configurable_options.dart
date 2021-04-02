import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class ProductConfigurableOptions extends StatelessWidget {
  final ProductEntity productEntity;
  final PageStyle pageStyle;

  ProductConfigurableOptions({this.productEntity, this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductChangeNotifier>(builder: (_, model, __) {
      return Container(
        width: pageStyle.deviceWidth,
        margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 20,
          vertical: pageStyle.unitHeight * 10,
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
                    fontSize: pageStyle.unitFontSize * 20,
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
                            horizontal: pageStyle.unitWidth * 4,
                            vertical: pageStyle.unitHeight * 5,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: pageStyle.unitWidth * 20,
                            vertical: pageStyle.unitHeight * 3,
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
                              fontSize: pageStyle.unitFontSize * 14,
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
