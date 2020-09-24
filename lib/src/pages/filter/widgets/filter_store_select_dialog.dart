import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterStoreSelectDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final List<String> values;
  final Function onChangedValue;

  FilterStoreSelectDialog({this.pageStyle, this.values, this.onChangedValue});

  @override
  _FilterStoreSelectDialogState createState() =>
      _FilterStoreSelectDialogState();
}

class _FilterStoreSelectDialogState extends State<FilterStoreSelectDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: widget.pageStyle.deviceWidth,
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 20,
          vertical: widget.pageStyle.unitHeight * 10,
        ),
        color: filterBackgroundColor.withOpacity(0.8),
        child: Column(
          children: [
            _buildDialogHeader(context),
            _buildDialogSearchInput(),
            _buildBrandList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'brands_title'.tr(),
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: widget.pageStyle.unitFontSize * 22,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(closeIcon, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSearchInput() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 10,
      ),
      child: TextFormField(
        style: mediumTextStyle.copyWith(
          fontSize: widget.pageStyle.unitFontSize * 15,
          color: greyColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.pageStyle.unitWidth * 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          hintText: 'filter_search_brand_hint'.tr(),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildBrandList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitHeight * 10),
      child: SelectOptionCustomStyle1(
        items: stores.map((e) => e.name).toList(),
        values: widget.values,
        itemWidth: double.infinity,
        itemHeight: widget.pageStyle.unitHeight * 50,
        titleSize: widget.pageStyle.unitFontSize * 16,
        selectedColor: Colors.transparent,
        selectedTitleColor: greyLightColor,
        selectedBorderColor: Colors.transparent,
        unSelectedColor: Colors.transparent,
        unSelectedTitleColor: greyLightColor,
        unSelectedBorderColor: Colors.transparent,
        // listStyle: true,
        onTap: (value) {
          widget.onChangedValue(value);
          setState(() {});
        },
      ),
    );
  }
}
