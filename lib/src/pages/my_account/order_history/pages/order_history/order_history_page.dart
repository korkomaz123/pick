import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets/order_card.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ProgressService progressService;
  late SnackBarService snackBarService;
  late OrderChangeNotifier orderChangeNotifier;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(context: context, scaffoldKey: scaffoldKey);
  }

  void _onRefresh() async {
    await orderChangeNotifier.loadOrderHistories(
      user!.token,
      lang,
      () => refreshController.refreshCompleted(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: 'my_orders'.tr()),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: null,
        child: Consumer<OrderChangeNotifier>(
          builder: (_, model, __) {
            if (model.ordersMap.isEmpty) {
              return Center(child: NoAvailableData(message: 'no_orders_list'.tr()));
            } else {
              return Column(
                children: [
                  _buildTitleBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        children: model.keys.map((key) {
                          return OrderCard(order: model.ordersMap[key]!);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.account),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          Text(
            'total'.tr() + ' ',
            style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 10.sp),
          ),
          Text(
            'items'.tr().replaceFirst('0', '${orderChangeNotifier.ordersMap.keys.toList().length}'),
            style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
