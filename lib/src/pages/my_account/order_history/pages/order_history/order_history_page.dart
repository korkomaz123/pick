import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_order_history_app_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/order_entity.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import '../../bloc/order_bloc.dart';

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
    orderBloc.add(OrderHistoryLoaded(token: user.token));
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
                        return _buildOrderItem(orders[index]);
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

  Widget _buildOrderItem(OrderEntity order) {
    String icon = '';
    Color color;
    String status = '';
    switch (order.status) {
      case OrderStatusEnum.pending:
        icon = pendingIcon;
        color = dangerColor;
        status = 'order_pending'.tr();
        break;
      case OrderStatusEnum.processing:
        icon = onProgressIcon;
        color = primaryColor;
        status = 'order_on_progress'.tr();
        break;
      case OrderStatusEnum.on_hold:
        icon = deliveredIcon;
        color = Color(0xFF32BEA6);
        status = 'order_delivered'.tr();
        break;
      case OrderStatusEnum.canceled:
        icon = cancelledIcon;
        color = Colors.grey;
        status = 'order_cancelled'.tr();
        break;
      default:
        icon = pendingIcon;
        color = orangeColor;
        status = EnumToString.convertToString(order.status).tr();
    }
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 15,
            ),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_no'.tr() + ' #${order.orderNo}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                SvgPicture.asset(icon),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_date'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.orderDate,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_status'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  status,
                  style: mediumTextStyle.copyWith(
                    color: color,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_payment_method'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.paymentMethod.title,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  'currency'.tr() + ' ${order.totalPrice}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.viewOrder,
                    arguments: order,
                  ),
                  height: pageStyle.unitHeight * 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.eye,
                        color: Colors.white54,
                        size: pageStyle.unitFontSize * 20,
                      ),
                      SizedBox(width: pageStyle.unitWidth * 6),
                      Text(
                        'view_order_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: pageStyle.unitWidth * 5),
                MaterialButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.reOrder,
                    arguments: order,
                  ),
                  minWidth: pageStyle.unitWidth * 150,
                  height: pageStyle.unitHeight * 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.history,
                        color: Colors.white54,
                        size: pageStyle.unitFontSize * 20,
                      ),
                      SizedBox(width: pageStyle.unitWidth * 4),
                      Text(
                        'reorder_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
