import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';

class SelectRegionDialog extends StatefulWidget {
  final String value;

  SelectRegionDialog({this.value});

  @override
  _SelectRegionDialogState createState() => _SelectRegionDialogState();
}

class _SelectRegionDialogState extends State<SelectRegionDialog> {
  final searchController = TextEditingController();
  _loadData() async {
    regions = await ShippingAddressRepository().getRegions(lang);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
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
                hintText: 'search_region_hint'.tr(),
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
          regions.isNotEmpty ? _buildRegionList() : _buildNoRegions(),
        ],
      ),
    );
  }

  Widget _buildNoRegions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        'no_available_regions'.tr(),
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget _buildRegionList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: regions.map((region) {
            bool isSelected = widget.value == region.regionId;
            int index = regions.indexOf(region);
            bool contain = searchController.text.isEmpty ||
                region.defaultName
                    .toString()
                    .toUpperCase()
                    .contains(searchController.text.toUpperCase());
            return contain
                ? Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context, region),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                region.defaultName,
                                style: mediumTextStyle.copyWith(
                                  fontSize: 16.sp,
                                  color:
                                      isSelected ? primaryColor : greyDarkColor,
                                ),
                              ),
                              isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: primaryColor,
                                      size: 20.sp,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      index < countries.length - 1
                          ? Divider(color: greyColor)
                          : SizedBox.shrink(),
                    ],
                  )
                : SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }
}
