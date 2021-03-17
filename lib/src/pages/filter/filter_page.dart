import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'bloc/filter_bloc.dart';
import 'widgets/filter_basic_select.dart';
import 'widgets/filter_category_select.dart';
import 'widgets/filter_option_select_dialog.dart';

class FilterPage extends StatefulWidget {
  final String categoryId;
  final String brandId;
  final double minPrice;
  final double maxPrice;
  final List<String> selectedCategories;
  final List<String> selectedGenders;
  final Map<String, dynamic> selectedValues;

  FilterPage({
    @required this.categoryId,
    @required this.brandId,
    this.minPrice,
    this.maxPrice,
    this.selectedCategories,
    this.selectedGenders,
    this.selectedValues,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  double minPrice;
  double maxPrice;
  Map<String, dynamic> filters = {};
  List<String> selectedCategories;
  List<String> selectedGenders;
  List<dynamic> genderList = [];
  Map<String, dynamic> price = {};
  Map<String, dynamic> selectedValues;
  ProgressService progressService;
  FlushBarService flushBarService;
  MarkaaAppChangeNotifier model;

  @override
  void initState() {
    super.initState();
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
    selectedCategories = widget.selectedCategories ?? [];
    selectedGenders = widget.selectedGenders ?? [];
    selectedValues = widget.selectedValues ?? {};
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    model = context.read<MarkaaAppChangeNotifier>();
  }

  void _setSelectedValues(Map<String, dynamic> availableFilters) {
    List<String> keys = availableFilters.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String code = availableFilters[keys[i]]['attribute_code'];
      if (!['price', 'gender', 'rating', 'cat', 'new', 'sale'].contains(code)) {
        if (!selectedValues.containsKey(code)) {
          selectedValues[code] = [];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: filterBackgroundColor,
      appBar: AppBar(
        backgroundColor: filterBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
            size: pageStyle.unitFontSize * 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'filter_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: primaryColor,
            fontSize: pageStyle.unitFontSize * 25,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 8,
              ),
              child: InkWell(
                onTap: () => _onResetAll(),
                child: Text(
                  'filter_reset_all'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<FilterBloc, FilterState>(
          listener: (context, state) {
            if (state is FilterAttributesLoadedInProcess) {
              // progressService.showProgress();
            }
            if (state is FilterAttributesLoadedSuccess) {
              // progressService.hideProgress();
              _setSelectedValues(state.availableFilters);
            }
            if (state is FilterAttributesLoadedFailure) {
              // progressService.hideProgress();
              flushBarService.showErrorMessage(pageStyle, state.message);
            }
          },
          builder: (context, state) {
            if (state is FilterAttributesLoadedSuccess) {
              filters = state.availableFilters;
              genderList = filters.containsKey('Gender')
                  ? filters['Gender']['values']
                  : [];
              price = filters.containsKey('Price')
                  ? filters['Price']
                  : {'min': .0, 'max': .0};
              minPrice = minPrice ?? price['min'] + .0;
              maxPrice = maxPrice ?? price['max'] + .0;
              return Column(
                children: [
                  _buildCategories(),
                  if (price.keys.toList().length > 0) ...[_buildPriceRange()],
                  if (genderList.isNotEmpty) ...[_buildGender()],
                  Consumer<MarkaaAppChangeNotifier>(builder: (_, __, ___) {
                    return Column(
                      children: filters.keys.map((key) {
                        String code = filters[key]['attribute_code'];
                        return [
                          'price',
                          'gender',
                          'rating',
                          'cat',
                          'new',
                          'sale'
                        ].contains(code)
                            ? SizedBox.shrink()
                            : _buildFilterOption(key, filters[key]);
                      }).toList(),
                    );
                  }),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomSheet: _buildApplyButton(),
    );
  }

  Widget _buildCategories() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: FilterCategorySelect(
        items: [
          {
            'display': homeCategories[0].name,
            'value': '${homeCategories[0].id}'
          },
          {
            'display': homeCategories[1].name,
            'value': '${homeCategories[1].id}'
          },
        ],
        itemWidth: pageStyle.unitWidth * 160,
        itemHeight: pageStyle.unitHeight * 40,
        values: selectedCategories,
        pageStyle: pageStyle,
        onTap: (value) {
          if (selectedCategories.contains(value['value'])) {
            selectedCategories.remove(value['value']);
          } else {
            selectedCategories.add(value['value']);
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildPriceRange() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'filter_price'.tr(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '${minPrice.toStringAsFixed(0)} ' +
                  'currency'.tr() +
                  ' - ' +
                  '${maxPrice.toStringAsFixed(0)} ' +
                  'currency'.tr(),
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: pageStyle.unitFontSize * 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            onChanged: (RangeValues values) {
              minPrice = values.start;
              maxPrice = values.end;
              setState(() {});
            },
            min: (price['min'] + .0),
            max: (price['max'] + .0),
            activeColor: primaryColor,
            inactiveColor: primaryColor.withOpacity(0.6),
            divisions: 200,
          )
        ],
      ),
    );
  }

  Widget _buildGender() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'filter_gender'.tr(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          FilterBasicSelect(
            pageStyle: pageStyle,
            width: double.infinity,
            options: genderList,
            values: selectedGenders,
            onSelectItem: (value) {
              if (selectedGenders.contains(value['value'])) {
                selectedGenders.remove(value['value']);
              } else {
                selectedGenders.add(value['value']);
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, Map<String, dynamic> filterOption) {
    return InkWell(
      onTap: () => _onSelectOption(title, filterOption),
      child: Container(
        width: pageStyle.deviceWidth,
        margin: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 30,
          vertical: pageStyle.unitHeight * 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: primaryColor, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: pageStyle.unitWidth * 8,
                  height: pageStyle.unitWidth * 8,
                  decoration: BoxDecoration(
                    color: !selectedValues
                                .containsKey(filterOption['attribute_code']) ||
                            selectedValues[filterOption['attribute_code']]
                                .isEmpty
                        ? Colors.white
                        : Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: pageStyle.unitWidth * 2),
                Text(
                  title,
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: pageStyle.unitFontSize * 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      child: MarkaaTextButton(
        title: 'apply_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 24,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        radius: 0,
        onPressed: () => Navigator.pop(context, {
          'selectedCategories': selectedCategories,
          'selectedGenders': selectedGenders,
          'minPrice': minPrice,
          'maxPrice': maxPrice,
          'selectedValues': selectedValues,
        }),
      ),
    );
  }

  void _onSelectOption(String title, Map<String, dynamic> option) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return FilterOptionSelectDialog(
          pageStyle: pageStyle,
          title: title,
          code: option['attribute_code'],
          options: option['values'] ?? [],
          values: selectedValues[option['attribute_code']] ?? [],
        );
      },
    );
    if (result != null) {
      selectedValues[option['attribute_code']] = result;
      model.rebuild();
    }
  }

  void _onResetAll() {
    selectedCategories.clear();
    selectedGenders.clear();
    selectedValues = {};
    minPrice = null;
    maxPrice = null;
    setState(() {});
  }
}
