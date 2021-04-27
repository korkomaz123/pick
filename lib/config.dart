import 'package:flutter/widgets.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'src/change_notifier/my_cart_change_notifier.dart';
import 'src/config/config.dart';
import 'src/data/mock/mock.dart';
import 'src/data/models/user_entity.dart';
import 'src/utils/repositories/local_storage_repository.dart';
import 'src/utils/repositories/sign_in_repository.dart';

class Config {
  static String baseUrl = "";
  static String imagesUrl = "";
  static String language = "en";

  static PageStyle pageStyle;
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  static MyCartChangeNotifier myCartChangeNotifier = MyCartChangeNotifier();
  static SignInRepository signInRepo = SignInRepository();

  static LocalStorageRepository localRepo = LocalStorageRepository();
  static Future<void> checkAppVersion() async {
    // final versionEntity = await AppRepository().checkAppVersion(Platform.isAndroid, lang);
    // if (versionEntity.updateMandatory) {
    //   Navigator.pushReplacementNamed(
    //     context,
    //     Routes.update,
    //     arguments: versionEntity.storeLink,
    //   );
    // } else if (versionEntity.canUpdate) {
    //   final result = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return UpdateAvailableDialog(
    //         title: versionEntity.dialogTitle,
    //         content: versionEntity.dialogContent,
    //       );
    //     },
    //   );
    //   if (result != null) {
    //     if (await canLaunch(versionEntity.storeLink)) {
    //       await launch(versionEntity.storeLink);
    //     }
    //   }
    // }
  }

  static loadAssets() async {
    if (signInRepo.getFirebaseUser() == null) {
      await signInRepo.loginFirebase(email: MarkaaReporter.email, password: MarkaaReporter.password);
    }
    await _getCurrentUser();
    // if (user?.token != null) {
    //   isNotification = await settingRepo.getNotificationSetting(user.token);
    //   wishlistChangeNotifier.getWishlistItems(user.token, lang);
    //   orderChangeNotifier.loadOrderHistories(user.token, lang);
    //   addressChangeNotifier.initialize();
    //   addressChangeNotifier.loadAddresses(user.token);
    // }
    // _loadExtraData();
  }
// void _loadExtraData() async {
//   shippingMethods = await checkoutRepo.getShippingMethod(lang);
//   paymentMethods = await checkoutRepo.getPaymentMethod(lang);
//   regions = await shippingAddressRepo.getRegions(lang);
// }

  static Future<void> _getCurrentUser() async {
    String token = await localRepo.getToken();
    if (token.isNotEmpty) {
      SignInRepository signInRepo = SignInRepository();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        result['data']['customer']['profileUrl'] = result['data']['profileUrl'];
        user = UserEntity.fromJson(result['data']['customer']);
      } else {
        await localRepo.removeToken();
      }
    }
  }

  static appOpen() async {
    await checkAppVersion();
    bool isExist = await LocalStorageRepository().existItem('usage');
    if (isExist) {
      loadAssets();
    }
  }
}
