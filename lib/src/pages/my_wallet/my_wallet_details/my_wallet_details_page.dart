import 'package:flutter/material.dart';

import 'widgets/my_wallet_details_header.dart';
import 'widgets/my_wallet_details_form.dart';
import 'widgets/my_wallet_details_transactions.dart';

class MyWalletDetailsPage extends StatefulWidget {
  final double amount;

  MyWalletDetailsPage({this.amount});

  @override
  _MyWalletDetailsPageState createState() => _MyWalletDetailsPageState();
}

class _MyWalletDetailsPageState extends State<MyWalletDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletDetailsHeader(),
      body: Column(
        children: [
          MyWalletDetailsForm(amount: widget.amount),
          Expanded(
            child: SingleChildScrollView(
              child: MyWalletDetailsTransactions(),
            ),
          ),
        ],
      ),
    );
  }
}
