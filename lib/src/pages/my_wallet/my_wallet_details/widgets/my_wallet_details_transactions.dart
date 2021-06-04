import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/transaction_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class MyWalletDetailsTransactions extends StatefulWidget {
  @override
  _MyWalletDetailsTransactionsState createState() =>
      _MyWalletDetailsTransactionsState();
}

class _MyWalletDetailsTransactionsState
    extends State<MyWalletDetailsTransactions> {
  WalletChangeNotifier _walletChangeNotifier;
  OrderChangeNotifier _orderChangeNotifier;

  @override
  void initState() {
    super.initState();
    _orderChangeNotifier = context.read<OrderChangeNotifier>();
    _walletChangeNotifier = context.read<WalletChangeNotifier>();
    _walletChangeNotifier.getTransactionHistory(token: user.token);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: designWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'last_transactions'.tr(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 23.sp,
            ),
          ),
          Consumer<WalletChangeNotifier>(
            builder: (_, model, __) {
              if (model.transactionsList == null) {
                return Center(
                  child: PulseLoadingSpinner(),
                );
              }
              return Column(
                children: model.transactionsList.map((item) {
                  if (item.type == TransactionType.admin) {
                    return _buildAdminDebitCard(item);
                  } else if (item.type == TransactionType.debit) {
                    return _buildUserDebitCard(item);
                  }
                  return _buildOrderCard(item);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDebitCard(TransactionEntity item) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      color: greyLightColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'thankyou'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 11.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    _getAmountString(item.amount, item.type),
                    style: mediumTextStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: succeedColor,
                    ),
                  ),
                  Text(
                    ' (${'kwd'.tr()})',
                    style: mediumTextStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: succeedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(markaaTextIcon, height: 18.h),
                  SizedBox(width: 5.w),
                  Text(
                    'debit'.tr(),
                    style: mediumTextStyle.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
              Text(
                'date'.tr() + ': ${item.date}',
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDebitCard(TransactionEntity item) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      color: greyLightColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'thankyou'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 11.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    _getAmountString(item.amount, item.type),
                    style: mediumTextStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: succeedColor,
                    ),
                  ),
                  Text(
                    ' (${'kwd'.tr()})',
                    style: mediumTextStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: succeedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'user_debit'.tr(),
                style: mediumTextStyle.copyWith(fontSize: 16.sp),
              ),
              Text(
                'date'.tr() + ': ${item.date}',
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'transaction_id'.tr() + ': ${item.number}',
                  style: mediumTextStyle.copyWith(fontSize: 14.sp),
                ),
                if (item.paymentMethod == 'knet') ...[
                  SvgPicture.asset(
                    'lib/public/icons/knet.svg',
                    height: 20.h,
                    width: 35.w,
                  ),
                ] else if (item.paymentMethod == 'tap') ...[
                  Row(
                    children: [
                      Image.asset(
                        'lib/public/images/visa-card.png',
                        height: 20.h,
                        width: 60.w,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      SvgPicture.asset(
                        'lib/public/icons/line.svg',
                        height: 20.h,
                        width: 10.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      SvgPicture.asset(
                        'lib/public/icons/master-card.svg',
                        height: 20.h,
                        width: 38.w,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(TransactionEntity item) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      color: greyLightColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'order_number'.tr(),
                style: mediumTextStyle.copyWith(fontSize: 11.sp),
              ),
              Row(
                children: [
                  Text(
                    _getAmountString(item.amount, item.type),
                    style: mediumTextStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: dangerColor,
                    ),
                  ),
                  Text(
                    ' (${'kwd'.tr()})',
                    style: mediumTextStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: dangerColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.viewOrder,
                  arguments: _orderChangeNotifier.ordersMap[item.orderId],
                ),
                child: Text(
                  '#${item.number}',
                  style: mediumTextStyle.copyWith(fontSize: 16.sp),
                ),
              ),
              Text(
                'date'.tr() + ': ${item.date}',
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAmountString(double amount, TransactionType type) {
    switch (type) {
      case TransactionType.order:
        return '- $amount';
        break;
      case TransactionType.bank:
        return '- $amount';
        break;
      case TransactionType.debit:
        return '+ $amount';
        break;
      case TransactionType.admin:
        return '+ $amount';
        break;
      default:
        return '- $amount';
    }
  }
}
