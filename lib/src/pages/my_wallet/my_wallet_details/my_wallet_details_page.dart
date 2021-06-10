import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';

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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      user = await Preload.currentUser;
      setState(() {});
    });
  }

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
