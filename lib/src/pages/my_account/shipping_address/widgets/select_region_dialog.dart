import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SelectRegionDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final String value;

  SelectRegionDialog({this.pageStyle, this.value});

  @override
  _SelectRegionDialogState createState() => _SelectRegionDialogState();
}

class _SelectRegionDialogState extends State<SelectRegionDialog> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              horizontal: widget.pageStyle.unitWidth * 4,
              vertical: widget.pageStyle.unitHeight * 5,
            ),
            child: TextFormField(
              controller: searchController,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: widget.pageStyle.unitFontSize * 16,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.pageStyle.unitWidth * 10,
                ),
                hintText: 'search_region_hint'.tr(),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: greyColor.withOpacity(0.3),
                prefixIcon: Icon(
                  Icons.search,
                  color: greyDarkColor,
                  size: widget.pageStyle.unitFontSize * 20,
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
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitHeight * 20),
      child: Text(
        'no_available_regions'.tr(),
        textAlign: TextAlign.center,
        style: mediumTextStyle.copyWith(
          fontSize: widget.pageStyle.unitFontSize * 18,
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
            bool contain = searchController.text.isEmpty || region.defaultName.toString().toUpperCase().contains(searchController.text.toUpperCase());
            return contain
                ? Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context, region),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.pageStyle.unitWidth * 10,
                            vertical: widget.pageStyle.unitHeight * 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                region.defaultName,
                                style: mediumTextStyle.copyWith(
                                  fontSize: widget.pageStyle.unitFontSize * 16,
                                  color: isSelected ? primaryColor : greyDarkColor,
                                ),
                              ),
                              isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: primaryColor,
                                      size: widget.pageStyle.unitFontSize * 20,
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
