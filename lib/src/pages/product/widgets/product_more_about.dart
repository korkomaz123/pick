import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/styles.dart';

class ProductMoreAbout extends StatelessWidget {
  final ProductEntity productEntity;

  ProductMoreAbout({required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        margin: EdgeInsets.only(top: 10.h),
        child: Html(
          data: """${productEntity.fullDescription ?? ''}""",
          style: {
            "p": Style.fromTextStyle(mediumTextStyle.copyWith(fontSize: 14.sp)),
            "span":
                Style.fromTextStyle(mediumTextStyle.copyWith(fontSize: 14.sp)),
          },
        ),
      ),
    );
  }
}
