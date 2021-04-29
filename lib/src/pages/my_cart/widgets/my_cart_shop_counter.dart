import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCartShopCounter extends StatefulWidget {
  /// the value of counter
  final int value;

  /// method handler called when click the left toolbar
  final Function onDecrement;

  /// method handler called when click the right toolbar
  final Function onIncrement;

  MyCartShopCounter({
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
            height: 25.h,
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(lang == 'ar' ? 10 : 0),
                bottomRight: Radius.circular(lang == 'ar' ? 10 : 0),
                topLeft: Radius.circular(lang == 'en' ? 10 : 0),
                bottomLeft: Radius.circular(lang == 'en' ? 10 : 0),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.remove, size: 18.sp),
          ),
        ),
        Container(
          height: 25.h,
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
            style: mediumTextStyle.copyWith(
              color: primarySwatchColor,
              fontSize: 15.sp,
            ),
          ),
        ),
        InkWell(
          onTap: widget.onIncrement == null
              ? () => _onIncrement()
              : widget.onIncrement,
          child: Container(
            height: 25.h,
            padding: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(lang == 'en' ? 10 : 0),
                bottomRight: Radius.circular(lang == 'en' ? 10 : 0),
                topLeft: Radius.circular(lang == 'ar' ? 10 : 0),
                bottomLeft: Radius.circular(lang == 'ar' ? 10 : 0),
              ),
            ),
            child: Icon(Icons.add, size: 18.sp),
          ),
        ),
      ],
    );
  }
}
