import 'package:flutter_html/flutter_html.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductMoreAbout extends StatelessWidget {
  final ProductEntity productEntity;

  ProductMoreAbout({this.productEntity});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        margin: EdgeInsets.only(top: 10.h),
        child: Html(data:
            //"""${(productEntity.shortDescription != productEntity.description ? productEntity.shortDescription : "") + ""}""" +
            """${productEntity.fullDescription}"""),
      ),
    );
  }
}
