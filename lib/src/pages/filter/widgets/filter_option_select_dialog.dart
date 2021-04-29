import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';

class FilterOptionSelectDialog extends StatefulWidget {
  final String title;
  final String code;
  final List<dynamic> options;
  final List<dynamic> values;

  FilterOptionSelectDialog({
    this.title,
    this.code,
    this.options,
    this.values,
  });

  @override
  _FilterOptionSelectDialogState createState() =>
      _FilterOptionSelectDialogState();
}

class _FilterOptionSelectDialogState extends State<FilterOptionSelectDialog> {
  String title;
  String code;
  List<dynamic> options;
  List<dynamic> values;
  TextEditingController searchController = TextEditingController();
  MarkaaAppChangeNotifier markaaAppChangeNotifier;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    code = widget.code;
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    searchController.addListener(() {
      markaaAppChangeNotifier.rebuild();
    });
    options = widget.options.map((option) => option).toList();
    values = widget.values.map((value) => value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: filterBackgroundColor,
      appBar: AppBar(
        backgroundColor: filterBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
            size: 22.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: mediumTextStyle.copyWith(
            color: primaryColor,
            fontSize: 25.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Center(
              child: InkWell(
                onTap: () => _onClear(),
                child: Text(
                  'reset'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (code == 'manufacturer') ...[_buildDialogSearchInput()],
          Consumer<MarkaaAppChangeNotifier>(
            builder: (_, __, ___) {
              return _buildOptionsList();
            },
          ),
        ],
      ),
      bottomSheet: _buildApplyButton(),
    );
  }

  Widget _buildDialogSearchInput() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: searchController,
        style: mediumTextStyle.copyWith(
          fontSize: 15.sp,
          color: greyColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: greyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor),
          ),
          hintText: 'filter_search_brand_hint'.tr(),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return Expanded(
      child: ListView.separated(
        itemCount: options.length,
        itemBuilder: (context, index) {
          dynamic value = options[index]['value'];
          dynamic title = options[index]['display'];
          int selIdx = values.indexOf(value);
          bool isSelected = selIdx >= 0;
          String query = searchController.text.toLowerCase();
          String item = title.toString().toLowerCase();
          if (item.contains(query)) {
            return InkWell(
              onTap: () => _onSelectItem(selIdx, options[index]),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (code == 'color') ...[
                          Container(
                            width: 30.w,
                            height: 30.w,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: _getColorFromHex(
                                  options[index]['color_code']),
                              shape: BoxShape.circle,
                            ),
                          )
                        ],
                        Text(
                          title,
                          style: mediumTextStyle.copyWith(
                            color: primaryColor,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected) ...[
                      Icon(
                        Icons.check,
                        size: 20.sp,
                        color: primaryColor,
                      )
                    ],
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        separatorBuilder: (context, index) {
          dynamic title = options[index]['display'];
          String query = searchController.text.toLowerCase();
          String item = title.toString().toLowerCase();
          if (index < options.length - 1) {
            if (item.contains(query)) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(color: primaryColor),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: 375.w,
      height: 60.h,
      child: MarkaaTextButton(
        title: 'apply_button_title'.tr(),
        titleSize: 24.sp,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        radius: 0,
        onPressed: () => Navigator.pop(context, values),
      ),
    );
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

  void _onSelectItem(int selIdx, Map<String, dynamic> item) {
    if (selIdx >= 0) {
      values.removeAt(selIdx);
    } else {
      values.add(item['value']);
    }
    markaaAppChangeNotifier.rebuild();
  }

  void _onClear() {
    values.clear();
    markaaAppChangeNotifier.rebuild();
  }
}
