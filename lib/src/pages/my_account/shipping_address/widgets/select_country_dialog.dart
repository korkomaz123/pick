import 'package:markaa/src/data/mock/countries.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCountryDialog extends StatefulWidget {
  final String value;

  SelectCountryDialog({required this.value});

  @override
  _SelectCountryDialogState createState() => _SelectCountryDialogState();
}

class _SelectCountryDialogState extends State<SelectCountryDialog> {
  String? value;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    value = widget.value;
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: greyLightColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 355.w,
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 5.h,
            ),
            child: TextFormField(
              controller: searchController,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                hintText: 'search_country_hint'.tr(),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: greyColor.withOpacity(0.3),
                prefixIcon: Icon(
                  Icons.search,
                  color: greyDarkColor,
                  size: 20.sp,
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
            bool contain = searchController.text.isEmpty ||
                country['name']
                    .toString()
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase());
            if (contain) {
              return Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, country),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 20.h,
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
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              country['name'] + ' (${country['code']})',
                              style: mediumTextStyle.copyWith(
                                fontSize: 14.sp,
                                color: isSelected
                                    ? primarySwatchColor
                                    : greyDarkColor,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            Icon(
                              Icons.check,
                              size: 18.sp,
                              color: primarySwatchColor,
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (index < countries.length - 1) ...[
                    Divider(color: greyColor)
                  ],
                ],
              );
            }
            return Container();
          }).toList(),
        ),
      ),
    );
  }
}
