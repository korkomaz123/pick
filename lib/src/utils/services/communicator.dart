import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';

class Communicator {
  final BuildContext context;

  Communicator({required this.context});

  MyCartChangeNotifier? _cartProvider;
  AuthChangeNotifier? _authProvider;

  double _cartTotalPrice = 0;
  double _walletAmount = 0;

  List<String> _cartMapKeys = [];

  subscribeToChangeNotifiers() {
    _cartProvider = context.read<MyCartChangeNotifier>();
    _authProvider = context.read<AuthChangeNotifier>();

    _cartProvider!.addListener(_onMyCartChanged);
    _authProvider!.addListener(_onAuthChanged);
  }

  _onMyCartChanged() {
    /// if cart total price has been changed, send total price to the onesignal
    if (_cartTotalPrice != _cartProvider!.cartTotalPrice) {
      _cartTotalPrice = _cartProvider!.cartTotalPrice;
      OneSignal.shared.sendTag('cartTotalPrice', _cartTotalPrice);
    }

    /// if item added | removed, send new | previous item to the onesignal
    List<String> keys = _cartProvider!.cartItemsMap.keys.toList();
    if (_cartMapKeys.length != keys.length) {
      if (keys.isNotEmpty) {
        String key = keys[keys.length - 1];
        final item = _cartProvider!.cartItemsMap[key];
        OneSignal.shared.sendTags({
          'cart_update': DateTime.now().millisecondsSinceEpoch,
          'product_name': item!.product.name,
          'product_image': item.product.imageUrl,
        });
      } else {
        OneSignal.shared.sendTags({
          'cart_update': '',
          'product_name': '',
          'product_image': '',
        });
      }
    }
  }

  _onAuthChanged() {
    /// send authentication status to the onesignal
    bool authenticated = _authProvider?.currentUser != null;
    OneSignal.shared.sendTag('authenticated', authenticated);

    /// if wallet has been changed, send wallet amount to the onesignal
    double amount = _authProvider?.currentUser?.balance ?? 0;
    if (_walletAmount != amount) {
      _walletAmount = amount;
      OneSignal.shared.sendTag('wallet', _walletAmount);
    }

    /// set user identity of the smartlook, onesignal
    Map<String, dynamic> userMap = _authProvider?.currentUser?.toJson() ?? {};
    OneSignal.shared.sendTags(userMap);
    Smartlook.setUserIdentifier('user_identity', {'authenticated': authenticated, ...userMap});
  }
}
