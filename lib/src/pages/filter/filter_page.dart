import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/filter_bloc.dart';
import 'widgets/filter_category_select.dart';
import 'widgets/filter_color_select.dart';
import 'widgets/filter_store_select_dialog.dart';

class FilterPage extends StatefulWidget {
  final String categoryId;

  FilterPage({this.categoryId});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  double minPrice = 0;
  double maxPrice = 10;
  List<String> selectedCategories = [];
  List<String> selectedGenders = [];
  List<String> selectedBrands = [];
  bool isHideSizes = true;
  bool isHideColors = true;
  bool isHideStores = true;
  List<String> selectedSizes = [];
  List<String> selectedColors = [];
  Map<String, Color> colors = {};
  ProgressService progressService;
  SnackBarService snackBarService;
  FilterBloc filterBloc;
  List<Map<String, dynamic>> brandList = [];
  List<Map<String, dynamic>> colorList = [];
  List<Map<String, dynamic>> genderList = [];
  List<Map<String, dynamic>> sizeList = [];

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

    for (int i = 0; i < colorItems.length; i++) {
      colors[colorItems[i]] = _getColorFromHex(colorItems[i]);
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Colors.transparent;
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
                  progressService.showProgress();
                }
                if (state is FilterAttributesLoadedSuccess) {
                  progressService.hideProgress();
                }
                if (state is FilterAttributesLoadedFailure) {
                  progressService.hideProgress();
                  snackBarService.showErrorSnackBar(state.message);
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    _buildAppBar(),
                    _buildCategories(),
                    _buildPriceRange(),
                    _buildGender(),
                    _buildSizes(),
                    _buildColors(),
                    _buildStores(),
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
        items: ['side_best_deals'.tr(), 'side_new_arrivals'.tr()],
        itemWidth: pageStyle.unitWidth * 160,
        itemHeight: pageStyle.unitHeight * 40,
        values: selectedCategories,
        pageStyle: pageStyle,
        onTap: (value) {
          if (selectedCategories.contains(value)) {
            selectedCategories.remove(value);
          } else {
            selectedCategories.add(value);
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
              '$minPrice KD - $maxPrice KD',
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
            min: 0,
            max: 10,
            activeColor: Colors.white,
            inactiveColor: Colors.white70,
            divisions: 20,
            labels: RangeLabels(
              'KD ' + minPrice.toString(),
              'KD ' + maxPrice.toString(),
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
          Container(
            width: double.infinity,
            // height: pageStyle.unitHeight * 32,
            child: SelectOptionCustom(
              items: GenderEnum.values
                  .map((e) => EnumToString.convertToString(e))
                  .toList(),
              itemWidth: pageStyle.unitWidth * 72,
              itemHeight: pageStyle.unitHeight * 31,
              values: selectedGenders,
              itemSpace: pageStyle.unitWidth * 6,
              titleSize: pageStyle.unitFontSize * 10,
              radius: 30,
              selectedColor: Colors.white,
              selectedBorderColor: Colors.transparent,
              selectedTitleColor: primaryColor,
              unSelectedColor: Colors.transparent,
              unSelectedBorderColor: Colors.white,
              unSelectedTitleColor: Colors.white,
              onTap: (value) {
                if (selectedGenders.contains(value)) {
                  selectedGenders.remove(value);
                } else {
                  selectedGenders.add(value);
                }
                setState(() {});
              },
            ),
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
              : Container(
                  width: double.infinity,
                  child: SelectOptionCustom(
                    items: ['S', 'M', 'L', 'XL', 'XXL'],
                    itemWidth: pageStyle.unitWidth * 60,
                    itemHeight: pageStyle.unitHeight * 31,
                    values: selectedSizes,
                    itemSpace: pageStyle.unitWidth * 6,
                    titleSize: pageStyle.unitFontSize * 12,
                    radius: 30,
                    selectedColor: Colors.white,
                    selectedBorderColor: Colors.transparent,
                    selectedTitleColor: primaryColor,
                    unSelectedColor: Colors.transparent,
                    unSelectedBorderColor: Colors.white,
                    unSelectedTitleColor: Colors.white,
                    onTap: (value) {
                      if (selectedSizes.contains(value)) {
                        selectedSizes.remove(value);
                      } else {
                        selectedSizes.add(value);
                      }
                      setState(() {});
                    },
                  ),
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
                    items: colorItems,
                    itemWidth: pageStyle.unitWidth * 30,
                    itemHeight: pageStyle.unitHeight * 30,
                    values: selectedColors,
                    pageStyle: pageStyle,
                    colors: colors,
                    onTap: (value) {
                      if (selectedColors.contains(value)) {
                        selectedColors.remove(value);
                      } else {
                        selectedColors.add(value);
                      }
                      setState(() {});
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStores() {
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
        children: selectedBrands.map((store) {
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
              store,
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
        onPressed: () => Navigator.pop(context),
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
    if (selectedBrands.contains(value)) {
      selectedBrands.remove(value);
    } else {
      selectedBrands.add(value);
    }
    setState(() {});
  }

  void _onResetAll() {
    minPrice = 0;
    maxPrice = 10;
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
}
