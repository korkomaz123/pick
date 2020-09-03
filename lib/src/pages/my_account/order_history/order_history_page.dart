import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_order_history_app_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/order_entity.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaOrderHistoryAppBar(pageStyle: pageStyle),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: pageStyle.deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 20,
                vertical: pageStyle.unitHeight * 30,
              ),
              child: Text(
                '2 ' + 'items'.tr(),
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
      case OrderStatusEnum.onProgress:
        icon = onProgressIcon;
        color = primaryColor;
        status = 'order_on_progress'.tr();
        break;
      case OrderStatusEnum.delivered:
        icon = deliveredIcon;
        color = Color(0xFF32BEA6);
        status = 'order_delivered'.tr();
        break;
      default:
        icon = pendingIcon;
        color = dangerColor;
        status = 'order_pending'.tr();
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
                  style: bookTextStyle.copyWith(
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
              vertical: pageStyle.unitHeight * 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_date'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.orderDate,
                  style: bookTextStyle.copyWith(
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
              vertical: pageStyle.unitHeight * 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_status'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  status,
                  style: bookTextStyle.copyWith(
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
              vertical: pageStyle.unitHeight * 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_payment_method'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.paymentMethod,
                  style: bookTextStyle.copyWith(
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
              vertical: pageStyle.unitHeight * 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  'currency'.tr() + ' ${order.totalPrice}',
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
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
