import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

import '../../../../preload.dart';

class AlarmListPage extends StatefulWidget {
  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressService progressService;
  @override
  void initState() {
    progressService = ProgressService(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      body: Column(
        children: [
          _buildAppBar(),
          _buildAboutUsView(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50.h,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 22.sp),
      ),
      centerTitle: true,
      title: Text(
        'alarm_list'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
    );
  }

  Widget _buildAboutUsView() {
    return Expanded(
      child: FutureBuilder(
        future: Api.getMethod(EndPoints.getAlarmItems, data: {"lang": lang, "email": user.email}, extra: {"refresh": true}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.data['items'] == null) return Container();
            return ListView.separated(
              padding: EdgeInsets.all(10.w),
              itemCount: snapshot.data['items'].length,
              separatorBuilder: (context, i) => Divider(),
              itemBuilder: (context, i) => Container(
                height: 80.h,
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: snapshot.data['items'][i]['productdetail']['image_url'],
                      width: 90.w,
                      height: 80.h,
                      fit: BoxFit.fitHeight,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['items'][i]['productdetail']['brand_label'],
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data['items'][i]['productdetail']['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          if (snapshot.data['items'][i]['status'] != '1')
                            Text(
                              snapshot.data['items'][i]['type'] == 'stock' ? "stock_notification".tr() : "price_notification".tr(),
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.sp),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.delete_outlined),
                            onPressed: () async {
                              progressService.showProgress();
                              ProductEntity _productEntity = ProductEntity.fromJson(snapshot.data['items'][i]['productdetail']);
                              if (snapshot.data['items'][i]['type'] == 'stock') {
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("${snapshot.data['items'][i]['productdetail']['product_id']}_product_instock_en");
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("${snapshot.data['items'][i]['productdetail']['product_id']}_product_instock_ar");
                                await _productEntity
                                    .requestPriceAlarm('remove', _productEntity.productId, data: {"stockItem_Id": snapshot.data['items'][i]['id']});
                              } else if (snapshot.data['items'][i]['type'] == 'price') {
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("${snapshot.data['items'][i]['productdetail']['product_id']}_product_price_en");
                                FirebaseMessaging.instance
                                    .unsubscribeFromTopic("${snapshot.data['items'][i]['productdetail']['product_id']}_product_price_ar");
                                await _productEntity
                                    .requestPriceAlarm('remove', _productEntity.productId, data: {"priceItem_Id": snapshot.data['items'][i]['id']});
                              }
                              progressService.hideProgress();
                              setState(() {});
                            }),
                        Spacer(),
                        Text(StringService.roundString(snapshot.data['items'][i]['productdetail']['price'], 3) + " " + "currency".tr())
                      ],
                    )
                  ],
                ),
              ),
            );
            //snapshot.data['stockitems']priceitems
          } else {
            return Center(
              child: PulseLoadingSpinner(),
            );
          }
        },
      ),
    );
  }
}
