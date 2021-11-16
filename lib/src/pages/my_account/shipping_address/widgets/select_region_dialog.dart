import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/mock/countries.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/app_repository.dart';

class SelectRegionDialog extends StatefulWidget {
  final String? value;

  SelectRegionDialog({this.value});

  @override
  _SelectRegionDialogState createState() => _SelectRegionDialogState();
}

class _SelectRegionDialogState extends State<SelectRegionDialog> {
  final searchController = TextEditingController();
  _loadData() async {
    try {
      regions = await AppRepository().getRegions();
      print(regions.length);
      setState(() {});
    } catch (e) {
      print('LOADING REGIONS ON REGION DIALOG CATCH ERROR: $e');
    }
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
      backgroundColor: greyLightColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
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
          regions.isNotEmpty ? _buildRegionList() : PulseLoadingSpinner(),
        ],
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
            if (contain) {
              return Column(
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
                            region.defaultName!,
                            style: mediumTextStyle.copyWith(
                              fontSize: 16.sp,
                              color: isSelected ? primaryColor : greyDarkColor,
                            ),
                          ),
                          if (isSelected) ...[
                            Icon(Icons.check, color: primaryColor, size: 20.sp)
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
