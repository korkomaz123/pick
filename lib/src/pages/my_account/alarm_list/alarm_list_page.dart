import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

class AlarmListPage extends StatefulWidget {
  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ProgressService progressService;

  @override
  void initState() {
    _getAlarmITems = Api.getMethod(
      EndPoints.getAlarmItems,
      data: {"lang": lang, "email": user?.email},
      extra: {"refresh": true},
    );
    progressService = ProgressService(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      body: Column(children: [_buildAppBar(), _buildAboutUsView()]),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50.h,
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, size: 22.sp)),
      centerTitle: true,
      title: Text(
        'alarm_list'.tr(),
        style: mediumTextStyle.copyWith(color: Colors.white, fontSize: 17.sp),
      ),
    );
  }

  _goDetails(context, product) {
    Navigator.pushNamed(
      context,
      Routes.product,
      arguments: ProductModel.fromJson(product),
    );
  }

  List<dynamic> _items = [];
  Future? _getAlarmITems;
  Widget _buildAboutUsView() {
    return Expanded(
      child: FutureBuilder<dynamic>(
        future: _getAlarmITems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!['items'] == null ||
                snapshot.data!['items'].isEmpty) return NoAvailableData(message: 'no_items_in_list');
            _items = snapshot.data['items'];
            return ListView.separated(
              padding: EdgeInsets.all(10.w),
              itemCount: _items.length,
              separatorBuilder: (context, i) => Divider(),
              itemBuilder: (context, i) => Container(
                height: 80.h,
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _goDetails(context, _items[i]['productdetail']);
                      },
                      child: CachedNetworkImage(
                        key: ValueKey(_items[i]['productdetail']['image_url']),
                        cacheKey: _items[i]['productdetail']['image_url'],
                        imageUrl: _items[i]['productdetail']['image_url'],
                        width: 90.w,
                        height: 80.h,
                        fit: BoxFit.fitHeight,
                        errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _goDetails(context, _items[i]['productdetail']);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[i]['productdetail']['brand_label'],
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _items[i]['productdetail']['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            if (_items[i]['status'].toString() != '1')
                              Text(
                                _items[i]['type'] == 'stock' ? "stock_notification".tr() : "price_notification".tr(),
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.sp),
                              ),
                            if (_items[i]['status'].toString() == '1')
                              Text(
                                _items[i]['type'] == 'stock'
                                    ? "stock_notification_fixed".tr()
                                    : "price_notification_fixed".tr(),
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10.sp),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          child: SvgPicture.asset("lib/public/icons/trash-icon.svg", color: Colors.black),
                          onTap: () async {
                            progressService.showProgress();
                            ProductEntity _productEntity = ProductEntity.fromJson(_items[i]['productdetail']);
                            if (_items[i]['type'] == 'stock') {
                              FirebaseMessaging.instance.unsubscribeFromTopic(
                                  "${_items[i]['productdetail']['product_id']}_product_instock_en");
                              FirebaseMessaging.instance.unsubscribeFromTopic(
                                  "${_items[i]['productdetail']['product_id']}_product_instock_ar");
                              await _productEntity.requestPriceAlarm('remove', _productEntity.productId,
                                  data: {"stockItem_Id": _items[i]['id']});
                            } else if (_items[i]['type'] == 'price') {
                              FirebaseMessaging.instance
                                  .unsubscribeFromTopic("${_items[i]['productdetail']['product_id']}_product_price_en");
                              FirebaseMessaging.instance
                                  .unsubscribeFromTopic("${_items[i]['productdetail']['product_id']}_product_price_ar");
                              await _productEntity.requestPriceAlarm('remove', _productEntity.productId,
                                  data: {"priceItem_Id": _items[i]['id']});
                            }
                            progressService.hideProgress();
                            _items.removeAt(i);
                            setState(() {});
                          },
                        ),
                        Spacer(),
                        Text(StringService.roundString(_items[i]['productdetail']['price'], 3) + " " + "currency".tr())
                      ],
                    )
                  ],
                ),
              ),
            );
            //snapshot.data['stockitems']priceitems
          } else {
            return Center(child: PulseLoadingSpinner());
          }
        },
      ),
    );
  }
}
