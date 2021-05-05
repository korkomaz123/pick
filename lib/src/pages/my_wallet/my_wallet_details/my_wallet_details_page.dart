import 'package:flutter/material.dart';

import 'widgets/my_wallet_details_header.dart';
import 'widgets/my_wallet_details_form.dart';
import 'widgets/my_wallet_details_transactions.dart';

class MyWalletDetailsPage extends StatefulWidget {
  @override
  _MyWalletDetailsPageState createState() => _MyWalletDetailsPageState();
}

class _MyWalletDetailsPageState extends State<MyWalletDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWalletDetailsHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyWalletDetailsForm(),
            MyWalletDetailsTransactions(),
          ],
        ),
      ),
    );
  }
}
