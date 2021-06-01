import 'dart:convert';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class WalletRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<String> createWalletCart() async {
    String url = EndPoints.createWalletCart;
    final result = await Api.getMethod(url);

    if (result['code'] == 'SUCCESS') {
      return result['cartId'];
    }
    return null;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> addMoneyToWallet(
    String cartId,
    String price,
    String lang,
  ) async {
    String url = EndPoints.addMoney;
    final params = {'cartId': cartId, 'price': price, 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    print(result);

    return result['code'] == 'SUCCESS';
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> transferMoneyToBank(
    String token,
    String amount,
    Map<String, dynamic> bankDetails,
    String walletNote,
  ) async {
    String url = EndPoints.transferMoney;
    final params = {
      'token': token,
      'amount': amount,
      'bank_details': jsonEncode(bankDetails),
      'walletnote': walletNote,
    };
    final result = await Api.postMethod(url, data: params);

    return result['code'] == 'SUCCESS';
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getTransactionHistory(String token) async {
    String url = EndPoints.getRecord;
    final params = {'token': token};
    final result = await Api.postMethod(url, data: params);

    return result;
  }
}
