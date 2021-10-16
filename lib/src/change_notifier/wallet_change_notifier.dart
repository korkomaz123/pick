import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/repositories/wallet_repository.dart';

class WalletChangeNotifier extends ChangeNotifier {
  final walletRepository = WalletRepository();
  final cartRepository = MyCartRepository();

  String? walletCartId;
  String? amount;

  List<BankAccountEntity>? banksList;
  List<TransactionEntity>? transactionsList;
  BankAccountEntity? selectedBank;

  void init() {
    print('clear wallet cart');
    walletCartId = null;
    amount = null;
    notifyListeners();
  }

  void createWalletCart({
    String? amount,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    print('create wallet cart: $walletCartId');
    if (onProcess != null) onProcess();

    try {
      if (walletCartId!.isNotEmpty) {
        if (this.amount == amount) {
          onSuccess!();
        } else {
          final result = await cartRepository.clearCartItems(walletCartId!);
          if (result['code'] == 'SUCCESS') {
            onSuccess!();
          } else {
            onFailure!();
          }
        }
      } else {
        walletCartId = await walletRepository.createWalletCart();
        if (walletCartId!.isEmpty) {
          onFailure!('Error');
        } else {
          onSuccess!();
        }
      }
    } catch (e) {
      onFailure!('connection_error');
    }
    notifyListeners();
  }

  void addMoneyToWallet({
    String? amount,
    String? lang,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    onProcess!();
    if (this.amount == amount) {
      onSuccess!();
    } else {
      final result = await walletRepository.addMoneyToWallet(
          walletCartId!, amount!, lang!);

      if (result['code'] == 'SUCCESS') {
        this.amount = amount;
        onSuccess!();
      } else {
        onFailure!();
      }
    }
    notifyListeners();
  }

  void transferMoneyToBank({
    String? token,
    String? amount,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    onProcess!();

    Map<String, dynamic> bankDetails = selectedBank!.toJson();
    String walletNote = '';
    final result = await walletRepository.transferMoneyToBank(
        token!, amount!, bankDetails, walletNote);

    if (result['code'] == 'SUCCESS') {
      onSuccess!();
    } else {
      onFailure!(result['errorMessage']);
    }
  }

  void transferMoney({
    String? token,
    String? amount,
    String? lang,
    String? description,
    String? email,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    onProcess!();

    final result = await walletRepository.transferMoney(
        token!, amount!, lang!, description!, email!);
    if (result['code'] == 'SUCCESS') {
      onSuccess!();
    } else {
      onFailure!(result['errorMessage']);
    }
  }

  void getTransactionHistory({String? token}) async {
    final result =
        await walletRepository.getTransactionHistory(token!, Preload.language);
    if (result['code'] == 'SUCCESS') {
      transactionsList = [];
      List<dynamic> list = result['data'];
      for (var item in list) {
        transactionsList!.add(TransactionEntity.fromJson(item));
      }
    } else {
      transactionsList = [];
    }
    notifyListeners();
  }
}
