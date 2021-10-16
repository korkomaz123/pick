import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class InfollowencerProductsPage extends StatefulWidget {
  final dynamic arguments;

  InfollowencerProductsPage({this.arguments});

  @override
  _InfollowencerProductsPageState createState() =>
      _InfollowencerProductsPageState();
}

class _InfollowencerProductsPageState extends State<InfollowencerProductsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductChangeNotifier? productChangeNotifier;
  Map<String, dynamic> filterValues = {};

  List<dynamic> items = [];
  dynamic _info = {};
  bool isLoading = true;
  void getAllCelebrities() async {
    items = [];
    setState(() => isLoading = true);
    final result = await Api.getMethod(EndPoints.celebrityProducts,
        data: {'lang': lang, 'customerId': widget.arguments['id'].toString()},
        extra: {"refresh": true});
    if (result['code'] == 'SUCCESS') {
      items = result['items'];
      _info = result['userinfo'];
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllCelebrities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Stack(
        children: [
          _buildBrandBar(),
          if (isLoading)
            Center(child: PulseLoadingSpinner())
          else
            Positioned(
                top: 150.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.blue,
                      height: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Wrap(
                            spacing: 2.w,
                            runSpacing: 2.w,
                            children: items
                                .map(
                                  (item) => ProductVCard(
                                    product: ProductModel.fromJson(item),
                                    cardWidth: 184.25.w,
                                    cardHeight: 280.h,
                                    isShoppingCart: true,
                                    isWishlist: true,
                                    isShare: true,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          _buildAppBar(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: 375.w,
        height: 40.h,
        color: primarySwatchColor,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${_info['firstname'] ?? ''} ${_info['lastname'] ?? ''}',
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 17.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBar() {
    return Positioned(
      top: 40.h,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.grey.shade100,
        height: 110.h,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_info['profile_picture'] != null)
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    CachedNetworkImageProvider(_info['profile_picture']),
                radius: 50,
              ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${_info['firstname'] ?? ''} ${_info['lastname'] ?? ''}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AvenirMedium',
                  ),
                ),
                if (_info['coupon'] != null &&
                    _info['coupon'].toString().isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: '${'coupon'.tr()} : ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AvenirMedium',
                      ),
                      children: [
                        TextSpan(
                          text: '${_info['coupon']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AvenirMedium',
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  'items'.tr().replaceAll('0', items.length.toString()),
                ),
              ],
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
