import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/repositories/wallet_repository.dart';

class WalletChangeNotifier extends ChangeNotifier {
  final walletRepository = WalletRepository();
  final cartRepository = MyCartRepository();

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
    String amount,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      if (walletCartId != null && walletCartId.isNotEmpty) {
        if (this.amount == amount) {
          if (onSuccess != null) onSuccess();
        } else {
          final result = await cartRepository.clearCartItems(walletCartId);
          if (result['code'] == 'SUCCESS') {
            if (onSuccess != null) onSuccess();
          } else {
            if (onFailure != null) onFailure();
          }
        }
      } else {
        walletCartId = await walletRepository.createWalletCart();
        if (walletCartId == null || walletCartId.isEmpty) {
          if (onFailure != null) onFailure('Error');
        } else {
          if (onSuccess != null) onSuccess();
        }
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
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
      print(result);

      if (result['code'] == 'SUCCESS') {
        this.amount = amount;
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
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

    if (result['code'] == 'SUCCESS') {
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure(result['errorMessage']);
    }
  }

  void transferMoney({
    String token,
    String amount,
    String lang,
    String description,
    String email,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    final result = await walletRepository.transferMoney(
        token, amount, lang, description, email);
    if (result['code'] == 'SUCCESS') {
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure(result['errorMessage']);
    }
  }

  void getTransactionHistory({String token}) async {
    final result =
        await walletRepository.getTransactionHistory(token, Preload.language);

    if (result['code'] == 'SUCCESS') {
      transactionsList = [];
      List<dynamic> list = result['data'];
      for (var item in list) {
        transactionsList.add(TransactionEntity.fromJson(item));
      }
    } else {
      transactionsList = [];
    }
    notifyListeners();
  }
}
