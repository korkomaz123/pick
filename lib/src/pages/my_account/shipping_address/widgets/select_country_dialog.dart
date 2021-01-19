import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SelectCountryDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final String value;

  SelectCountryDialog({this.pageStyle, this.value});

  @override
  _SelectCountryDialogState createState() => _SelectCountryDialogState();
}

class _SelectCountryDialogState extends State<SelectCountryDialog> {
  PageStyle pageStyle;
  String value;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    value = widget.value;
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 4,
              vertical: pageStyle.unitHeight * 5,
            ),
            child: TextFormField(
              controller: searchController,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 16,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 10,
                ),
                hintText: 'search_country_hint'.tr(),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: greyColor.withOpacity(0.3),
                prefixIcon: Icon(
                  Icons.search,
                  color: greyDarkColor,
                  size: pageStyle.unitFontSize * 20,
                ),
              ),
            ),
          ),
          _buildCountriesList(),
        ],
      ),
    );
  }

  Widget _buildCountriesList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: countries.map((country) {
            bool isSelected = value == country['code'];
            int index = countries.indexOf(country);
            bool contain = searchController.text.isEmpty || country['name'].toString().toUpperCase().contains(searchController.text.toUpperCase());
            return contain
                ? Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context, country),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: pageStyle.unitWidth * 20,
                            vertical: pageStyle.unitHeight * 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: pageStyle.unitWidth * 30,
                                height: pageStyle.unitHeight * 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'lib/public/images/flags/${country['code'].toLowerCase()}.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(width: pageStyle.unitWidth * 10),
                              Expanded(
                                child: Text(
                                  country['name'] + ' (${country['code']})',
                                  style: mediumTextStyle.copyWith(
                                      fontSize: pageStyle.unitFontSize * 14, color: isSelected ? primarySwatchColor : greyDarkColor),
                                ),
                              ),
                              isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: pageStyle.unitFontSize * 18,
                                      color: primarySwatchColor,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      index < countries.length - 1 ? Divider(color: greyColor) : SizedBox.shrink(),
                    ],
                  )
                : SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }
}
