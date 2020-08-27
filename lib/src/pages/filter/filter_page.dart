import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  PageStyle pageStyle;
  double minPrice = 0;
  double maxPrice = 10;
  String gender;
  List<String> selectedStores = [];

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
            _buildPriceRange(),
            _buildGender(),
            _buildStoreChoice(),
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
          FlutterSlider(
            values: [minPrice, maxPrice],
            rangeSlider: true,
            max: 10,
            min: 0,
            tooltip: FlutterSliderTooltip(
              leftSuffix: Text(' KD'),
              rightSuffix: Text(' KD'),
            ),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              minPrice = lowerValue;
              maxPrice = upperValue;
              setState(() {});
            },
          ),
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
            height: pageStyle.unitHeight * 32,
            child: SelectOptionCustom(
              items: GenderEnum.values
                  .map((e) => EnumToString.parse(e).toUpperCase())
                  .toList(),
              itemWidth: pageStyle.unitWidth * 82,
              itemHeight: pageStyle.unitHeight * 31,
              value: gender,
              itemSpace: 1,
              titleSize: pageStyle.unitFontSize * 12,
              radius: 30,
              selectedColor: Colors.transparent,
              selectedBorderColor: Colors.white,
              selectedTitleColor: Colors.white,
              unSelectedColor: Colors.white,
              unSelectedBorderColor: Colors.black.withOpacity(0.6),
              unSelectedTitleColor: greyDarkColor,
              listStyle: true,
              isVertical: false,
              onTap: (value) {
                if (value != gender) {
                  setState(() {
                    gender = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreChoice() {
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
            'Store',
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 22,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Container(
            width: double.infinity,
            height: pageStyle.unitHeight * 190,
            child: SelectOptionCustomStyle1(
              items: stores.map((e) => e.name).toList(),
              values: selectedStores,
              itemWidth: pageStyle.unitWidth * 303,
              itemHeight: pageStyle.unitHeight * 39.5,
              selectedColor: Colors.transparent,
              selectedTitleColor: Colors.white,
              selectedBorderColor: Colors.white,
              unSelectedColor: Colors.white,
              unSelectedTitleColor: greyDarkColor,
              unSelectedBorderColor: greyDarkColor,
              listStyle: true,
              isVertical: true,
              onTap: (value) {
                if (selectedStores.contains(value)) {
                  selectedStores.remove(value);
                } else {
                  selectedStores.add(value);
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
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
      child: TextButton(
        title: 'Apply',
        titleSize: pageStyle.unitFontSize * 24,
        titleColor: primaryColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        radius: 30,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
