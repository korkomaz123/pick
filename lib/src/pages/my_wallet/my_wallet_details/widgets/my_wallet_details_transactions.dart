import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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
              return Column(
                children: model.transactionsList.map((item) {
                  return _buildTransactionItemCard(item);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItemCard(TransactionEntity item) {
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
                _getTransactionTypeString(item.type),
                style: mediumTextStyle.copyWith(fontSize: 11.sp),
              ),
              Row(
                children: [
                  Text(
                    _getAmountString(item.amount),
                    style: mediumTextStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: item.amount > 0 ? succeedColor : dangerColor,
                    ),
                  ),
                  Text(
                    ' (${'kwd'.tr()})',
                    style: mediumTextStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: item.amount > 0 ? succeedColor : dangerColor,
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
                '#${item.number}',
                style: mediumTextStyle.copyWith(fontSize: 16.sp),
              ),
              Text(
                'Date: ${item.date}',
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

  String _getTransactionTypeString(TransactionType type) {
    switch (type) {
      case TransactionType.order:
        return 'Order Number';
        break;
      case TransactionType.bank:
        return 'Bank Transfer';
        break;
      case TransactionType.debit:
        return 'User Debit';
        break;
      default:
        return 'Order Number';
    }
  }

  String _getAmountString(double amount) {
    return amount > 0 ? '+ $amount' : '- ${-amount}';
  }
}
