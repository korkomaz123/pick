import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  PageStyle pageStyle;
  double minPrice = 0;
  double maxPrice = 10;
  String category;
  String gender;
  List<String> selectedStores = [];
  bool isHideSizes = true;
  bool isHideColors = true;
  bool isHideStores = true;
  String size;
  String color;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Material(
      color: filterBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategories(),
            _buildPriceRange(),
            _buildGender(),
            _buildSizes(),
            _buildColors(),
            _buildStores(),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: filterBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: pageStyle.unitFontSize * 22,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Filter',
        style: boldTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 25,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: pageStyle.unitWidth * 10),
          child: Center(
            child: InkWell(
              onTap: () => null,
              child: Text(
                'Reset All',
                style: bookTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: SelectOptionCustom(
        items: ['BEST DEALS', 'NEW ARRIVALS'],
        itemWidth: pageStyle.unitWidth * 160,
        itemHeight: pageStyle.unitHeight * 40,
        value: category,
        itemSpace: pageStyle.unitWidth * 10,
        titleSize: pageStyle.unitFontSize * 15,
        radius: 30,
        selectedColor: primaryColor,
        selectedBorderColor: Colors.transparent,
        selectedTitleColor: Colors.white,
        unSelectedColor: greyLightColor,
        unSelectedBorderColor: Colors.transparent,
        unSelectedTitleColor: greyDarkColor,
        onTap: (value) {
          if (value != category) {
            category = value;
          } else {
            category = '';
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildPriceRange() {
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price',
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 22,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '0 KD - 10 KD',
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
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
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
                  .map((e) => EnumToString.parse(e).toUpperCase())
                  .toList(),
              itemWidth: pageStyle.unitWidth * 82,
              itemHeight: pageStyle.unitHeight * 31,
              value: gender,
              itemSpace: pageStyle.unitWidth * 10,
              titleSize: pageStyle.unitFontSize * 12,
              radius: 30,
              selectedColor: Colors.white,
              selectedBorderColor: Colors.transparent,
              selectedTitleColor: primaryColor,
              unSelectedColor: Colors.transparent,
              unSelectedBorderColor: Colors.white,
              unSelectedTitleColor: Colors.white,
              onTap: (value) {
                if (value != gender) {
                  gender = value;
                } else {
                  gender = '';
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
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
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
                  'Sizes',
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
                    value: size,
                    itemSpace: pageStyle.unitWidth * 10,
                    titleSize: pageStyle.unitFontSize * 12,
                    radius: 30,
                    selectedColor: Colors.white,
                    selectedBorderColor: Colors.transparent,
                    selectedTitleColor: primaryColor,
                    unSelectedColor: Colors.transparent,
                    unSelectedBorderColor: Colors.white,
                    unSelectedTitleColor: Colors.white,
                    onTap: (value) {
                      if (value != size) {
                        size = value;
                      } else {
                        size = '';
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
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
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
                  'Colors',
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
                  child: SelectOptionCustom(
                    items: ['RED', 'YELLOW', 'PURPLE', 'BLUE'],
                    itemWidth: pageStyle.unitWidth * 80,
                    itemHeight: pageStyle.unitHeight * 31,
                    value: color,
                    itemSpace: pageStyle.unitWidth * 10,
                    titleSize: pageStyle.unitFontSize * 12,
                    radius: 30,
                    selectedColor: Colors.white,
                    selectedBorderColor: Colors.transparent,
                    selectedTitleColor: primaryColor,
                    unSelectedColor: Colors.transparent,
                    unSelectedBorderColor: Colors.white,
                    unSelectedTitleColor: Colors.white,
                    onTap: (value) {
                      if (value != color) {
                        color = value;
                      } else {
                        color = '';
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
        vertical: pageStyle.unitHeight * 20,
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
                  'Stores',
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 22,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    isHideStores = !isHideStores;
                  }),
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

  Widget _buildApplyButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      margin: EdgeInsets.only(top: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'Apply',
        titleSize: pageStyle.unitFontSize * 24,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        radius: 0,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
