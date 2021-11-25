import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/env.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';
import 'package:markaa/src/utils/repositories/wallet_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WalletChangeNotifier extends ChangeNotifier {
  final walletRepository = WalletRepository();
  final cartRepository = MyCartRepository();
  final orderRepository = OrderRepository();
  final firebaseRepository = FirebaseRepository();

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
      if (walletCartId != null && walletCartId!.isNotEmpty) {
        if (this.amount == amount) {
          if (onSuccess != null) onSuccess();
        } else {
          final result = await cartRepository.clearCartItems(walletCartId!);
          if (result['code'] == 'SUCCESS') {
            if (onSuccess != null) onSuccess();
          } else {
            if (onFailure != null) onFailure();
          }
        }
      } else {
        walletCartId = await walletRepository.createWalletCart();
        if (walletCartId != null && walletCartId!.isEmpty) {
          if (onFailure != null) onFailure('Error');
        } else {
          if (onSuccess != null) onSuccess();
        }
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
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
    if (onProcess != null) onProcess();
    if (this.amount == amount) {
      if (onSuccess != null) onSuccess();
    } else {
      final result = await walletRepository.addMoneyToWallet(walletCartId!, amount!, lang!);

      if (result['code'] == 'SUCCESS') {
        this.amount = amount;
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure();
      }
    }
    notifyListeners();
  }

  Future<void> getPaymentUrl(
    Map<String, dynamic> walletDetails,
    String lang, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    var result;
    try {
      String isVirtual = '1';
      result = await orderRepository.placeOrder(walletDetails, lang, isVirtual);

      if (result['code'] == 'SUCCESS') {
        submitWalletResult(result, walletDetails);
        if (onSuccess != null) onSuccess(result['payurl'], result);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
        reportWalletIssue(result, walletDetails);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
      reportWalletIssue(
        {'code': 'Catch Error: $e', 'errorMessage': result},
        walletDetails,
      );
    }
  }

  Future<void> cancelWalletPayment(
    dynamic walletResult, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
    Map<String, dynamic>? params,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await orderRepository.cancelOrderById(walletResult['order']['entity_id'], Preload.language);

      if (result['code'] == 'SUCCESS') {
        submitCanceledWalletResult(walletResult, params);
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  void transferMoneyToBank({
    String? token,
    String? amount,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();

    Map<String, dynamic> bankDetails = selectedBank!.toJson();
    String walletNote = '';
    final result = await walletRepository.transferMoneyToBank(token!, amount!, bankDetails, walletNote);

    if (result['code'] == 'SUCCESS') {
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure(result['errorMessage']);
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
    if (onProcess != null) onProcess();

    final result = await walletRepository.transferMoney(token!, amount!, lang!, description!, email!);
    if (result['code'] == 'SUCCESS') {
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure(result['errorMessage']);
    }
  }

  void getTransactionHistory({String? token}) async {
    final result = await walletRepository.getTransactionHistory(token!, Preload.language);
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

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<dynamic> addDeviceInfo(dynamic details) async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    details['appInfo'] = {
      'appName': _packageInfo.appName,
      'packageName': _packageInfo.packageName,
      'version': _packageInfo.version,
      'buildNumber': _packageInfo.buildNumber,
      'buildSignature': _packageInfo.buildSignature,
    };
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    details['deviceInfo'] = deviceData;
    return details;
  }

  void reportWalletIssue(dynamic result, dynamic walletDetails) async {
    SlackChannels.send(
      '$env Error Wallet: [${result['code']}] : ${result['errorMessage']} \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
      SlackChannels.logAddWalletError,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'walletDetails': await addDeviceInfo(walletDetails),
      'customer': user!.toJson(),
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion},
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.WALLET_ISSUE_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(reportData, path);
  }

  void submitWalletResult(
    dynamic result,
    Map<String, dynamic> walletDetails,
  ) async {
    SlackChannels.send(
      '''$env New Wallet: [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}] [totalPrice : ${result['order']['base_grand_total']}] \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}]''',
      SlackChannels.logAddWalletSuccess,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'walletDetails': await addDeviceInfo(walletDetails),
      'customer': user!.toJson(),
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion},
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.WALLET_RESULT_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${result['orderNo']}', resultData);
  }

  void submitCanceledWalletResult(dynamic result, [Map<String, dynamic>? params]) async {
    SlackChannels.send(
      params != null
          ? '''$env Wallet Canceled: [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}] [totalPrice : ${result['order']['base_grand_total']}] \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl] \r\n [payment_result => $params]'''
          : '''$env Wallet Canceled: [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}] [totalPrice : ${result['order']['base_grand_total']}] \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]''',
      SlackChannels.logWalletPaymentCanceled,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'customer': user!.toJson(),
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion},
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.WALLET_CANCELED_RESULT_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${result['orderNo']}', resultData);
  }

  void submitPaymentFailedWalletResult(dynamic result, Map<String, dynamic> params) async {
    SlackChannels.send(
      '''$env Wallet Payment Failed: [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}] [totalPrice : ${result['order']['base_grand_total']}] \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl] \r\n [payment_result => $params]''',
      SlackChannels.logWalletPaymentFailed,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'customer': user!.toJson(),
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion},
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.WALLET_PAYMENT_FAILED_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${result['orderNo']}', resultData);
  }

  void submitPaymentSuccessWalletResult(dynamic result, Map<String, dynamic> params) async {
    SlackChannels.send(
      '''$env Wallet Payment Success: [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}] [totalPrice : ${result['order']['base_grand_total']}] \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [payment_result => $params]''',
      SlackChannels.logWalletPaymentSuccess,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'customer': user!.toJson(),
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion},
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.WALLET_PAYMENT_SUCCESS_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${result['orderNo']}', resultData);
  }
}
