import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/wallet_repository.dart';

class WalletChangeNotifier extends ChangeNotifier {
  final walletRepository = WalletRepository();

  String walletCartId;

  String amount;

  List<BankAccountEntity> banksList;

  BankAccountEntity selectedBank;

  List<TransactionEntity> transactionsList;

  void init() {
    walletCartId = null;
    amount = null;
  }

  void createWalletCart({
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    if (walletCartId != null && walletCartId.isNotEmpty) {
      if (onSuccess != null) onSuccess();
    } else {
      walletCartId = await walletRepository.createWalletCart();

      if (walletCartId == null || walletCartId.isEmpty) {
        if (onFailure != null) onFailure();
      } else {
        if (onSuccess != null) onSuccess();
      }
    }
  }

  void addMoneyToWallet({
    String amount,
    String lang,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    if (this.amount == amount) {
      if (onSuccess != null) onSuccess();
    } else {
      final result =
          await walletRepository.addMoneyToWallet(walletCartId, amount, lang);

      if (result) {
        this.amount = amount;
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure();
      }
    }
  }

  void transferMoneyToBank({
    String token,
    String amount,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    Map<String, dynamic> bankDetails = selectedBank.toJson();
    String walletNote = '';
    final result = await walletRepository.transferMoneyToBank(
        token, amount, bankDetails, walletNote);

    if (result) {
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure();
    }
  }

  void getTransactionHistory({String token}) async {
    transactionsList = [];
    final result = await walletRepository.getTransactionHistory(token);

    if (result['code'] == 'SUCCESS') {
      List<dynamic> list = result['data'];
      for (var item in list) {
        transactionsList.add(TransactionEntity.fromJson(item));
      }
    }
    notifyListeners();
  }
}
