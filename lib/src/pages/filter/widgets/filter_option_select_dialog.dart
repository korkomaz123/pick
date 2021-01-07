import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FilterOptionSelectDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final String title;
  final String code;
  final List<dynamic> options;
  final List<dynamic> values;

  FilterOptionSelectDialog({
    this.pageStyle,
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

  @override
  void initState() {
    super.initState();
    print(widget.values);
    title = widget.title;
    code = widget.code;
    options = widget.options;
    values = widget.values;
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
            size: widget.pageStyle.unitFontSize * 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: mediumTextStyle.copyWith(
            color: primaryColor,
            fontSize: widget.pageStyle.unitFontSize * 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _onClear(),
            icon: SvgPicture.asset(closeIcon, color: primaryColor),
          ),
        ],
      ),
      body: Column(
        children: [
          code == 'manufacturer'
              ? _buildDialogSearchInput()
              : SizedBox.shrink(),
          _buildOptionsList(),
        ],
      ),
    );
  }

  Widget _buildDialogSearchInput() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: widget.pageStyle.unitWidth * 20,
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
          return InkWell(
            onTap: () => _onSelectItem(selIdx, options[index]),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 30,
              ),
              padding: EdgeInsets.symmetric(
                vertical: widget.pageStyle.unitHeight * 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      code == 'color'
                          ? Container(
                              width: widget.pageStyle.unitWidth * 30,
                              height: widget.pageStyle.unitWidth * 30,
                              margin: EdgeInsets.only(
                                right: widget.pageStyle.unitWidth * 10,
                              ),
                              decoration: BoxDecoration(
                                color: _getColorFromHex(
                                    options[index]['color_code']),
                                shape: BoxShape.circle,
                              ),
                            )
                          : SizedBox.shrink(),
                      Text(
                        title,
                        style: mediumTextStyle.copyWith(
                          color: primaryColor,
                          fontSize: widget.pageStyle.unitFontSize * 18,
                        ),
                      ),
                    ],
                  ),
                  isSelected
                      ? Icon(
                          Icons.check,
                          size: widget.pageStyle.unitFontSize * 20,
                          color: primaryColor,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return index < options.length - 1
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.pageStyle.unitWidth * 20,
                  ),
                  child: Divider(color: primaryColor),
                )
              : SizedBox.shrink();
        },
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
    setState(() {});
  }

  void _onClear() {
    values.clear();
    setState(() {});
  }
}
