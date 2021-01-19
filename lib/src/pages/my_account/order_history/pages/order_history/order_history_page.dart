import 'package:markaa/src/components/ciga_bottom_bar.dart';
import 'package:markaa/src/components/ciga_order_history_app_bar.dart';
import 'package:markaa/src/components/ciga_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  OrderBloc orderBloc;
  List<OrderEntity> orders = [];

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
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaOrderHistoryAppBar(pageStyle: pageStyle),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderHistoryLoadedInProcess) {
            progressService.showProgress();
          }
          if (state is OrderHistoryLoadedSuccess) {
            progressService.hideProgress();
          }
          if (state is OrderHistoryLoadedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is OrderHistoryLoadedSuccess) {
            orders = state.orders;
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
                        return OrderCard(
                          order: orders[index],
                          pageStyle: pageStyle,
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
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }
}
