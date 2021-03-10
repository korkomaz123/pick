import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_order_history_app_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets/order_card.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  OrderChangeNotifier orderChangeNotifier;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
  }

  void _onRefresh() async {
    await orderChangeNotifier.loadOrderHistories(
      user.token,
      lang,
      () {
        refreshController.refreshCompleted();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaOrderHistoryAppBar(pageStyle: pageStyle),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: null,
        child: Consumer<OrderChangeNotifier>(
          builder: (_, model, __) {
            print('history1');
            if (model.ordersMap.isEmpty) {
              return Center(
                child: NoAvailableData(
                  pageStyle: pageStyle,
                  message: 'no_orders_list'.tr(),
                ),
              );
            } else {
              print('history2');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: pageStyle.deviceWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: pageStyle.unitWidth * 20,
                        vertical: pageStyle.unitHeight * 30,
                      ),
                      child: Text(
                        'items'.tr().replaceFirst(
                            '0', '${model.ordersMap.keys.toList().length}'),
                        style: mediumTextStyle.copyWith(
                          color: primaryColor,
                          fontSize: pageStyle.unitFontSize * 14,
                        ),
                      ),
                    ),
                    Container(
                      width: pageStyle.deviceWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: pageStyle.unitWidth * 20,
                      ),
                      child: Column(
                        children: model.keys.map((key) {
                          return OrderCard(
                            order: model.ordersMap[key],
                            pageStyle: pageStyle,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }
}
