import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_order_history_app_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import '../../bloc/order_bloc.dart';
import '../../widgets/order_card.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final dataKey = GlobalKey();
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  OrderBloc orderBloc;
  List<OrderEntity> orders;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    orderBloc = context.read<OrderBloc>();
    orderBloc.add(OrderHistoryLoaded(token: user.token, lang: lang));
  }

  @override
  void dispose() {
    orderBloc.add(OrderHistoryInitialized());
    super.dispose();
  }

  void _reloadPage() {
    orderBloc.add(OrderHistoryInitialized());
    Future.delayed(Duration(milliseconds: 500), () {
      orderBloc.add(OrderHistoryLoaded(token: user.token, lang: lang));
    });
  }

  void _moveToActiveItem() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(dataKey.currentContext);
    });
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
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderHistoryLoadedInProcess) {
            // progressService.showProgress();
          }
          if (state is OrderHistoryLoadedSuccess) {
            // progressService.hideProgress();
            _moveToActiveItem();
          }
          if (state is OrderHistoryLoadedFailure) {
            // progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
          if (state is OrderCancelledSuccess) {
            Navigator.popUntil(
              context,
              (route) => route.settings.name == Routes.orderHistory,
            );
            _reloadPage();
          }
          if (state is OrderReturnedSuccess) {
            Navigator.popUntil(
              context,
              (route) => route.settings.name == Routes.orderHistory,
            );
            _reloadPage();
          }
        },
        builder: (context, state) {
          if (state is OrderHistoryLoadedSuccess) {
            orders = state.orders;
          }
          if (state is OrderHistoryInitializedSuccess) {
            orders = null;
          }
          if (orders == null) {
            return Center(
              child: PulseLoadingSpinner(),
            );
          }
          if (orders.isEmpty) {
            return Center(
              child: NoAvailableData(
                pageStyle: pageStyle,
                message: 'no_orders_list'.tr(),
              ),
            );
          }
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
                    'items'.tr().replaceFirst('0', '${orders.length}'),
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
                    children: List.generate(
                      orders.length,
                      (index) {
                        return Container(
                          key: activeIndex == index ? dataKey : null,
                          child: OrderCard(
                            order: orders[index],
                            pageStyle: pageStyle,
                            onTap: () {
                              activeIndex = index;
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }
}
