import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/string_service.dart';

import 'product_more_about.dart';
import 'product_review.dart';

class ProductDetailsTabs extends StatefulWidget {
  final ProductEntity productEntity;
  final ProductChangeNotifier model;
  ProductDetailsTabs({this.productEntity, this.model});

  @override
  _ProductDetailsTabsState createState() => _ProductDetailsTabsState();
}

class _ProductDetailsTabsState extends State<ProductDetailsTabs>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: _tabController?.index ?? 0);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            labelPadding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.black,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            labelStyle: mediumTextStyle,
            tabs: [
              Tab(text: "more_details".tr()),
              Tab(text: "specifications".tr()),
              Tab(text: "product_reviews".tr()),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Column(
            children: [
              if (_tabController.index == 1) ...[
                if (widget.productEntity?.specification == null)
                  Container()
                else
                  Column(
                    children: widget.productEntity.specification
                        .map(
                          (e) => Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5.w),
                                  margin: EdgeInsets.only(
                                    left: 10.w,
                                    right: 1.w,
                                    top: 1.w,
                                    bottom: 1.w,
                                  ),
                                  color: greyColor.withOpacity(0.1),
                                  child: Text(
                                    e.label,
                                    style: mediumTextStyle.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5.w),
                                  margin: EdgeInsets.only(
                                    right: 10.w,
                                    left: 1.w,
                                    top: 1.w,
                                    bottom: 1.w,
                                  ),
                                  color: greyColor.withOpacity(0.1),
                                  child: Text(
                                    e.code == "price"
                                        ? StringService.roundString(
                                                e.value, 3) +
                                            " " +
                                            'currency'.tr()
                                        : e.value,
                                    style: mediumTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
              ],
              if (_tabController.index == 2)
                ProductReview(product: widget.productEntity),
              ProductMoreAbout(productEntity: widget.productEntity),
            ],
          ),
        ],
      ),
    );
  }
}
