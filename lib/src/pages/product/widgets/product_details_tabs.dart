import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_configurable_options.dart';
import 'product_more_about.dart';
import 'product_review.dart';

class ProductDetailsTabs extends StatefulWidget {
  final ProductEntity productEntity;
  final ProductChangeNotifier model;
  ProductDetailsTabs({this.productEntity, this.model});

  @override
  _ProductDetailsTabsState createState() => _ProductDetailsTabsState();
}

class _ProductDetailsTabsState extends State<ProductDetailsTabs> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(
        length: 3, //model.productDetailsMap[productId].typeId == 'configurable' ? 3 : 2,
        vsync: this,
        initialIndex: _tabController?.index ?? 0);
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
            tabs: [
              Tab(text: "more_details".tr()),
              // if (productEntity.typeId == 'configurable')
              Tab(text: "specifications".tr()),
              Tab(text: "product_reviews".tr()),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.8,
            child: TabBarView(
              children: [
                ProductMoreAbout(productEntity: widget.productEntity),
                // if (productEntity.typeId == 'configurable')
                ProductConfigurableOptions(
                  productEntity: widget.productEntity,
                  model: widget.model,
                ),
                ProductReview(product: widget.productEntity),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
