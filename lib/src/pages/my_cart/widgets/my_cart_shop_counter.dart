import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class MyCartShopCounter extends StatefulWidget {
  /// page style
  final PageStyle pageStyle;

  /// the value of counter
  final int value;

  /// method handler called when click the left toolbar
  final Function onDecrement;

  /// method handler called when click the right toolbar
  final Function onIncrement;

  MyCartShopCounter({
    @required this.pageStyle,
    @required this.value,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  _MyCartShopCounterState createState() => _MyCartShopCounterState();
}

class _MyCartShopCounterState extends State<MyCartShopCounter> {
  int value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  void _onIncrement() {
    setState(() {
      value++;
    });
  }

  void _onDecrement() {
    setState(() {
      value--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: widget.onDecrement == null
              ? () => _onDecrement()
              : widget.onDecrement,
          child: Container(
            height: widget.pageStyle.unitHeight * 25,
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'ar'
                      ? 10
                      : 0,
                ),
                bottomRight: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'ar'
                      ? 10
                      : 0,
                ),
                topLeft: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'en'
                      ? 10
                      : 0,
                ),
                bottomLeft: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'en'
                      ? 10
                      : 0,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.remove, size: widget.pageStyle.unitFontSize * 18),
          ),
        ),
        Container(
          height: widget.pageStyle.unitHeight * 25,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: greyColor),
              bottom: BorderSide(color: greyColor),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.value.toString(),
            style: boldTextStyle.copyWith(
              color: primarySwatchColor,
              fontSize: widget.pageStyle.unitFontSize * 15,
            ),
          ),
        ),
        InkWell(
          onTap: widget.onIncrement == null
              ? () => _onIncrement()
              : widget.onIncrement,
          child: Container(
            height: widget.pageStyle.unitHeight * 25,
            padding: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'en'
                      ? 10
                      : 0,
                ),
                bottomRight: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'en'
                      ? 10
                      : 0,
                ),
                topLeft: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'ar'
                      ? 10
                      : 0,
                ),
                bottomLeft: Radius.circular(
                  EasyLocalization.of(context).locale.languageCode == 'ar'
                      ? 10
                      : 0,
                ),
              ),
            ),
            child: Icon(Icons.add, size: widget.pageStyle.unitFontSize * 18),
          ),
        ),
      ],
    );
  }
}
