import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/filter_bloc.dart';
import 'widgets/filter_basic_select.dart';
import 'widgets/filter_category_select.dart';
import 'widgets/filter_color_select.dart';
import 'widgets/filter_store_select_dialog.dart';

class FilterPage extends StatefulWidget {
  final String categoryId;

  FilterPage({@required this.categoryId});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  double minPrice;
  double maxPrice;
  List<String> selectedCategories = [];
  List<String> selectedGenders = [];
  List<String> selectedBrands = [];
  List<dynamic> brands = [];
  bool isHideSizes = true;
  bool isHideColors = true;
  bool isHideStores = true;
  List<String> selectedSizes = [];
  List<String> selectedColors = [];
  List<dynamic> brandList = [];
  List<dynamic> colorList = [];
  List<dynamic> genderList = [];
  List<dynamic> sizeList = [];
  Map<String, dynamic> price = {};
  FilterBloc filterBloc;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    filterBloc = context.bloc<FilterBloc>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    filterBloc.add(FilterAttributesLoaded(
      categoryId: widget.categoryId,
      lang: lang,
    ));
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: filterBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: BlocConsumer<FilterBloc, FilterState>(
              listener: (context, state) {
                if (state is FilterAttributesLoadedInProcess) {
                  // progressService.showProgress();
                }
                if (state is FilterAttributesLoadedSuccess) {
                  // progressService.hideProgress();
                }
                if (state is FilterAttributesLoadedFailure) {
                  // progressService.hideProgress();
                  snackBarService.showErrorSnackBar(state.message);
                }
                if (state is FilteredInProcess) {
                  // progressService.showProgress();
                }
                if (state is FilteredSuccess) {
                  // progressService.hideProgress();
                  Navigator.pop(context, state.products);
                }
                if (state is FilteredFailure) {
                  // progressService.hideProgress();
                  flushBarService.showErrorMessage(pageStyle, state.message);
                }
              },
              builder: (context, state) {
                if (state is FilterAttributesLoadedSuccess) {
                  brandList = state.availableFilters['Brand'];
                  colorList = state.availableFilters['Color'];
                  genderList = state.availableFilters['Gender'];
                  sizeList = state.availableFilters['Size'];
                  price = state.availableFilters['Price'];
                  minPrice = minPrice ?? (price['min'] + .0);
                  maxPrice = maxPrice ?? (price['max'] + .0);
                }
                return Column(
                  children: [
                    _buildAppBar(),
                    _buildCategories(),
                    price.keys.toList().length > 0
                        ? _buildPriceRange()
                        : SizedBox.shrink(),
                    genderList != null ? _buildGender() : SizedBox.shrink(),
                    sizeList != null ? _buildSizes() : SizedBox.shrink(),
                    colorList != null ? _buildColors() : SizedBox.shrink(),
                    brandList != null ? _buildBrands() : SizedBox.shrink(),
                    _buildSelectedBrands(),
                    SizedBox(height: pageStyle.unitHeight * 100),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildApplyButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: filterBackgroundColor,
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.only(top: pageStyle.unitHeight * 30),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: pageStyle.unitFontSize * 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'filter_title'.tr(),
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 25,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: pageStyle.unitWidth * 8.0),
            child: InkWell(
              onTap: () => _onResetAll(),
              child: Text(
                'filter_reset_all'.tr(),
                style: bookTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 16,
                ),
              ),
            ),
          ),
        ],
      ),
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
          {'display': 'side_best_deals', 'value': '41'},
          {'display': 'side_new_arrivals', 'value': '42'}
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
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 22,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '${minPrice.toStringAsFixed(0)} KD - ${maxPrice.toStringAsFixed(0)} KD',
              style: boldTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 25,
              ),
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            onChanged: (RangeValues values) {
              minPrice = values.start;
              maxPrice = values.end;
              setState(() {});
            },
            min: (price['min'] + .0),
            max: (price['max'] + .0),
            activeColor: Colors.white,
            inactiveColor: Colors.white70,
            divisions: 200,
            labels: RangeLabels(
              'KD ' + minPrice.toStringAsFixed(0),
              'KD ' + maxPrice.toStringAsFixed(0),
            ),
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
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 22,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 20),
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

  Widget _buildSizes() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: greyLightColor, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'filter_size'.tr(),
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 22,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    isHideSizes = !isHideSizes;
                  }),
                  icon: Icon(
                    isHideSizes
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: pageStyle.unitFontSize * 25,
                  ),
                ),
              ],
            ),
          ),
          isHideSizes
              ? SizedBox.shrink()
              : FilterBasicSelect(
                  pageStyle: pageStyle,
                  width: double.infinity,
                  options: sizeList,
                  values: selectedSizes,
                  onSelectItem: (value) {
                    if (selectedSizes.contains(value['value'])) {
                      selectedSizes.remove(value['value']);
                    } else {
                      selectedSizes.add(value['value']);
                    }
                    setState(() {});
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildColors() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: greyLightColor, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'filter_color'.tr(),
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 22,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    isHideColors = !isHideColors;
                  }),
                  icon: Icon(
                    isHideColors
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: pageStyle.unitFontSize * 25,
                  ),
                ),
              ],
            ),
          ),
          isHideColors
              ? SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: pageStyle.unitHeight * 10),
                  child: FilterColorSelect(
                    items: colorList,
                    itemWidth: pageStyle.unitWidth * 30,
                    itemHeight: pageStyle.unitHeight * 30,
                    values: selectedColors,
                    pageStyle: pageStyle,
                    onTap: (value) {
                      if (selectedColors.contains(value['value'])) {
                        selectedColors.remove(value['value']);
                      } else {
                        selectedColors.add(value['value']);
                      }
                      setState(() {});
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildBrands() {
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: greyLightColor, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'brands_title'.tr(),
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 22,
                  ),
                ),
                IconButton(
                  onPressed: () => _onStore(),
                  icon: Icon(
                    isHideStores
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: pageStyle.unitFontSize * 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedBrands() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 2,
      ),
      child: Wrap(
        spacing: pageStyle.unitWidth * 6,
        runSpacing: pageStyle.unitHeight * 2,
        children: brands.map((brand) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Text(
              brand['display'],
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: pageStyle.unitFontSize * 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      margin: EdgeInsets.only(top: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'apply_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 24,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        radius: 0,
        onPressed: () => _onFilter(),
      ),
    );
  }

  void _onStore() async {
    final result = await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          cornerRadius: 16,
          snapSpec: SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return FilterStoreSelectDialog(
              pageStyle: pageStyle,
              options: brandList,
              values: selectedBrands,
              onChangedValue: (value) => _onChangedValue(value),
            );
          },
        );
      },
    );
    print(result);
  }

  void _onChangedValue(value) {
    if (selectedBrands.contains(value['value'])) {
      selectedBrands.remove(value['value']);
      brands.remove(value);
    } else {
      selectedBrands.add(value['value']);
      brands.add(value);
    }
    setState(() {});
  }

  void _onResetAll() {
    minPrice = price['min'] + .0;
    maxPrice = price['max'] + .0;
    selectedCategories = [];
    selectedGenders = [];
    selectedBrands = [];
    isHideSizes = true;
    isHideColors = true;
    isHideStores = true;
    selectedSizes = [];
    selectedColors = [];
    setState(() {});
  }

  void _onFilter() {
    filterBloc.add(Filtered(
      categoryIds: selectedCategories,
      priceRanges: [minPrice.toStringAsFixed(0), maxPrice.toStringAsFixed(0)],
      genders: selectedGenders,
      sizes: selectedSizes,
      colors: selectedColors,
      brands: selectedBrands,
      lang: lang,
    ));
  }
}
