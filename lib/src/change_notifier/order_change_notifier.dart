import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      onSuccess!();
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

  Future<void> submitOrder(
    Map<String, dynamic> orderDetails,
    String lang, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
    bool isWallet = false,
  }) async {
    onProcess!();
    try {
      try {
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
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        }
        orderDetails['deviceInfo'] = deviceData;
      } catch (e) {}

      String isVirtual = isWallet ? '1' : '0';

      final result =
          await orderRepository.placeOrder(orderDetails, lang, isVirtual);
      submitOrderResult(result, orderDetails);

      if (result['code'] == 'SUCCESS') {
        final OrderEntity newOrder = OrderEntity.fromJson(result['order']);

        SlackChannels.send(
          '''new Order [${result['code']}] [${newOrder.status.toString()}] => [id : ${newOrder.orderNo}] [cart : ${newOrder.cartId}] [${newOrder.paymentMethod.title}]\r\n[totalPrice : ${newOrder.totalPrice}] [${user?.email ?? 'guest'}=>${user?.customerId ?? 'guest'}]''',
          SlackChannels.logAddOrder,
        );
        if (orderDetails['token'] != null &&
            orderDetails['token'] != '' &&
            !isWallet) {
          ordersMap[newOrder.orderId] = newOrder;

          await loadOrderHistories(user!.token, lang);
          setKeys();
          notifyListeners();
        }

        onSuccess!(result['payurl'], newOrder);
      } else {
        SlackChannels.send(
          'new Order [${result['code']}] : ${result['errorMessage']}',
          SlackChannels.logAddOrder,
        );

        onFailure!(result['errorMessage']);
        reportOrderIssue(result, orderDetails);
      }
    } catch (e) {
      onFailure!('connection_error');
      reportOrderIssue(e.toString(), orderDetails);
    }
  }

  Future<void> cancelFullOrder(
    OrderEntity order, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    onProcess!();
    try {
      final orderId = order.orderId;
      final result =
          await orderRepository.cancelOrderById(orderId, Preload.language);

      if (result['code'] == 'SUCCESS') {
        if (user?.token != null && ordersMap.containsKey(order.orderId)) {
          ordersMap.remove(order.orderId);
        }
        notifyListeners();
        onSuccess!();
      } else {
        onFailure!(result['errorMessage']);
      }
    } catch (e) {
      onFailure!('connection_error');
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
    onProcess!();
    try {
      final result = await orderRepository.cancelOrder(
          orderId, items, additionalInfo, reason, product, imageName);
      if (result['code'] == 'SUCCESS') {
        final canceledOrder = OrderEntity.fromJson(result['order']);
        ordersMap[orderId] = canceledOrder;
        notifyListeners();
        onSuccess!();
      } else {
        onFailure!(result['errorMessage']);
      }
    } catch (e) {
      onFailure!('connection_error');
    }
  }

  Future<void> returnOrder(
    String token,
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await orderRepository.returnOrder(
          token, orderId, items, additionalInfo, reason, product, imageName);
      if (result['code'] == 'SUCCESS') {
        onSuccess();
      } else {
        onFailure(result['errorMessage']);
      }
    } catch (e) {
      onFailure('connection_error');
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
    onProcess!();

    try {
      final result = await orderRepository.sendAsGift(
          token!, sender!, receiver!, message!);
      if (result['code'] == 'SUCCESS') {
        onSuccess!(result['gift_message_id']);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      onFailure!('connection_error');
    }
  }

  void reportOrderIssue(dynamic result, dynamic orderDetails) async {
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'orderDetails': orderDetails,
      'customer': user?.token != null ? user!.toJson() : 'guest',
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

  void submitOrderResult(dynamic result, dynamic orderDetails) async {
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'orderDetails': orderDetails,
      'customer': user?.token != null ? user!.toJson() : 'guest',
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
    await firebaseRepository.addToCollection(resultData, path);
  }
}
