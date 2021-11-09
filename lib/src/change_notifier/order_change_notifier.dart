import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/env.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OrderChangeNotifier extends ChangeNotifier {
  final OrderRepository orderRepository = OrderRepository();
  final FirebaseRepository firebaseRepository = FirebaseRepository();

  Map<String, OrderEntity> ordersMap = {};
  List<String> keys = [];

  OrderChangeNotifier() {
    initializeOrders();
  }
  void initializeOrders() {
    ordersMap = {};
    keys = [];
    notifyListeners();
  }

  void setKeys() {
    keys = ordersMap.keys.toList();
    keys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
  }

  Future<void> loadOrderHistories(
    String token,
    String lang, [
    Function? onSuccess,
  ]) async {
    final result = await orderRepository.getOrderHistory(token, lang);
    if (result['code'] == 'SUCCESS') {
      ordersMap = {};
      List<dynamic> ordersList = result['orders'];
      for (int i = 0; i < ordersList.length; i++) {
        final order = OrderEntity.fromJson(ordersList[i]);
        ordersMap[order.orderId] = order;
      }
      setKeys();
      notifyListeners();
      if (onSuccess != null) onSuccess();
    }
  }

  void removeOrder(OrderEntity order) {
    if (ordersMap.containsKey(order.orderId)) {
      ordersMap.remove(order.orderId);
      setKeys();
      notifyListeners();
    }
  }

  void updateOrder(OrderEntity order) {
    if (ordersMap.containsKey(order.orderId)) {
      ordersMap[order.orderId] = order;
      setKeys();
      notifyListeners();
    }
  }

  Future<void> submitOrder(
    Map<String, dynamic> orderDetails,
    String lang, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    var result;
    try {
      String isVirtual = '0';
      result = await orderRepository.placeOrder(orderDetails, lang, isVirtual);

      if (result['code'] == 'SUCCESS') {
        await submitOrderResult(result, orderDetails);
        final OrderEntity newOrder = OrderEntity.fromJson(result['order']);
        if (user != null) {
          ordersMap[newOrder.orderId] = newOrder;
          await loadOrderHistories(user!.token, lang);
          setKeys();
          notifyListeners();
        }
        if (onSuccess != null) onSuccess(result['payurl'], newOrder);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
        reportOrderIssue(result, orderDetails);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
      reportOrderIssue(
        {'code': 'Catch Error $e', 'errorMessage': result},
        orderDetails,
      );
    }
  }

  Future<void> cancelFullOrder(
    OrderEntity order, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await orderRepository.cancelOrderById(
          order.orderId, Preload.language);

      if (result['code'] == 'SUCCESS') {
        if (user?.token != null && ordersMap.containsKey(order.orderId)) {
          ordersMap.remove(order.orderId);
        }
        submitCanceledOrderResult(order);
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> cancelOrder(
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await orderRepository.cancelOrder(
          orderId, items, additionalInfo, reason, product, imageName);

      if (result['code'] == 'SUCCESS') {
        final canceledOrder = OrderEntity.fromJson(result['order']);
        ordersMap[orderId] = canceledOrder;
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> returnOrder(
    String token,
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await orderRepository.returnOrder(
          token, orderId, items, additionalInfo, reason, product, imageName);
      if (result['code'] == 'SUCCESS') {
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> sendAsGift({
    String? token,
    String? sender,
    String? receiver,
    String? message,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result = await orderRepository.sendAsGift(
          token!, sender!, receiver!, message!);
      if (result['code'] == 'SUCCESS') {
        if (onSuccess != null) onSuccess(result['gift_message_id']);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
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
    orderDetails['appInfo'] = {
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

  void reportOrderIssue(dynamic result, dynamic orderDetails) async {
    SlackChannels.send(
      '$env Order Error [${result['code']}] : ${result['errorMessage']} \r\n [cartId => ${orderDetails['cartId']}] [totalPrice => ${orderDetails['orderDetails']['totalPrice']}] [${orderDetails['paymentMethod']}] [${orderDetails['shipping']}] [Phone: ${result['order']['shippingAddress']['telephone']}] \r\n [Version => Android ${MarkaaVersion.androidVersion} iOS ${MarkaaVersion.iOSVersion}]',
      SlackChannels.logOrderError,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'orderDetails': await addDeviceInfo(orderDetails),
      'customer': user != null ? user!.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.ORDER_ISSUE_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(reportData, path);
  }

  Future submitOrderResult(dynamic result, dynamic orderDetails) async {
    SlackChannels.send(
      '''$env New Order [${result['order']['entity_id']}] => [orderNo : ${result['orderNo']}] [cart : ${result['order']['quote_id']}] [${result['order']['payment_code']}]\r\n[totalPrice : ${result['order']['base_grand_total']}] [${user?.email ?? 'guest'}] [Phone: ${result['order']['shippingAddress']['telephone']}]  \r\n [Version => Android ${MarkaaVersion.androidVersion} iOS ${MarkaaVersion.iOSVersion}]''',
      SlackChannels.logAddOrder,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'orderDetails': await addDeviceInfo(orderDetails),
      'customer': user != null ? user!.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.ORDER_RESULT_COLL_PATH.replaceFirst('date', date);
    return await firebaseRepository.setDoc(
        '$path/${result['orderNo']}', resultData);
  }

  void submitCanceledOrderResult(OrderEntity order) async {
    SlackChannels.send(
      '''$env Order Payment Canceled [${order.orderId}] => [orderNo : ${order.orderNo}] [cart : ${order.cartId}] [${order.paymentMethod.id}]\r\n[totalPrice : ${order.totalPrice}] [${user?.email ?? 'guest'}] [Phone: ${order.address.phoneNumber ?? ''}] \r\n [Version => Android ${MarkaaVersion.androidVersion} iOS ${MarkaaVersion.iOSVersion}]''',
      SlackChannels.logCanceledByUserOrder,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'orderId': order.orderId,
      'orderNo': order.orderNo,
      'customer': user != null ? user!.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path =
        FirebasePath.CANCELED_ORDER_RESULT_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${order.orderNo}', resultData);
  }

  void submitPaymentFailedOrderResult(OrderEntity order) async {
    SlackChannels.send(
      '''$env Order Payment Failed: [${order.orderId}] => [orderNo : ${order.orderNo}] [cart : ${order.cartId}] [${order.paymentMethod.id}]\r\n[totalPrice : ${order.totalPrice}] [${user?.email ?? 'guest'}] [Phone: ${order.address.phoneNumber ?? ''}] \r\n [Version => Android ${MarkaaVersion.androidVersion} iOS ${MarkaaVersion.iOSVersion}]''',
      SlackChannels.logPaymentFailedOrder,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'orderId': order.orderId,
      'orderNo': order.orderNo,
      'customer': user != null ? user!.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.PAYMENT_FAILED_ORDER_RESULT_COLL_PATH
        .replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${order.orderNo}', resultData);
  }

  void submitPaymentSuccessOrderResult(OrderEntity order) async {
    SlackChannels.send(
      '''$env Order Payment Success: [${order.orderId}] => [orderNo : ${order.orderNo}] [cart : ${order.cartId}] [${order.paymentMethod.id}]\r\n[totalPrice : ${order.totalPrice}] [${user?.email ?? 'guest'}] [Phone: ${order.address.phoneNumber ?? ''}] \r\n [Version => Android ${MarkaaVersion.androidVersion} iOS ${MarkaaVersion.iOSVersion}]''',
      SlackChannels.logPaymentSuccessOrder,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'orderId': order.orderId,
      'orderNo': order.orderNo,
      'customer': user != null ? user!.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.PAYMENT_SUCCESS_ORDER_RESULT_COLL_PATH
        .replaceFirst('date', date);
    await firebaseRepository.setDoc('$path/${order.orderNo}', resultData);
  }
}
