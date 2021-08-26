import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';

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
    Function onSuccess,
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
      if (onSuccess != null) {
        onSuccess();
      }
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
    Function onProcess,
    Function onSuccess,
    Function onFailure,
    bool isWallet = false,
  }) async {
    onProcess();
    try {
      String isVirtual = isWallet ? '1' : '0';
      final result =
          await orderRepository.placeOrder(orderDetails, lang, isVirtual);
      print(result);
      submitOrderResult(result, orderDetails);
      if (result['code'] == 'SUCCESS') {
        final newOrder = OrderEntity.fromJson(result['order']);
        if (orderDetails['token'] != null &&
            orderDetails['token'] != '' &&
            !isWallet) {
          ordersMap[newOrder.orderId] = newOrder;

          await loadOrderHistories(user.token, lang);
          setKeys();
          notifyListeners();
        }

        onSuccess(result['payurl'], newOrder);
      } else {
        onFailure(result['errorMessage']);
        reportOrderIssue(result, orderDetails);
      }
    } catch (e) {
      onFailure(e.toString());
      reportOrderIssue(e.toString(), orderDetails);
    }
  }

  Future<void> cancelFullOrder(
    OrderEntity order, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final orderId = order.orderId;

      final result =
          await orderRepository.cancelOrderById(orderId, Preload.language);

      if (result['code'] == 'SUCCESS') {
        if (user?.token != null && ordersMap.containsKey(order.orderId)) {
          ordersMap.remove(order.orderId);
        }
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  Future<void> cancelOrder(
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
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
      if (onFailure != null) onFailure(e.toString());
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
      onFailure(e.toString());
    }
  }

  Future<void> sendAsGift({
    String token,
    String sender,
    String receiver,
    String message,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      final result =
          await orderRepository.sendAsGift(token, sender, receiver, message);
      if (result['code'] == 'SUCCESS') {
        if (onSuccess != null) onSuccess(result['gift_message_id']);
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure(e.toString());
    }
  }

  void reportOrderIssue(dynamic result, dynamic orderDetails) async {
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'orderDetails': orderDetails,
      'customer': user?.token != null ? user.toJson() : 'guest',
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
      'customer': user?.token != null ? user.toJson() : 'guest',
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
