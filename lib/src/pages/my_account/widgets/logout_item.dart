import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';

class LogoutItem extends StatefulWidget {
  final SnackBarService snackBarService;
  final ProgressService progressService;

  LogoutItem({this.snackBarService, this.progressService});

  @override
  _LogoutItemState createState() => _LogoutItemState();
}

class _LogoutItemState extends State<LogoutItem> {
  SnackBarService snackBarService;
  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localRepo = LocalStorageRepository();
  SettingRepository settingRepo = SettingRepository();

  AuthChangeNotifier authChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    snackBarService = widget.snackBarService;
    progressService = widget.progressService;
    flushBarService = FlushBarService(context: context);

    authChangeNotifier = context.read<AuthChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _logout(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.h,
                  child: SvgPicture.asset(logoutCustomIcon),
                ),
                SizedBox(width: 10.w),
                Text(
                  'account_logout'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    final result = await flushBarService.showConfirmDialog(
        message: 'logout_confirm_dialog_text');
    if (result != null) {
      authChangeNotifier.logout(
        onProcess: _onProcess,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  _onProcess() {
    progressService.showProgress();
  }

  _onFailure(message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  void _onSuccess() async {
    await localRepo.setToken('');
    await settingRepo.updateFcmDeviceToken(user.token, '', '', lang, lang);

    orderChangeNotifier.initializeOrders();
    wishlistChangeNotifier.initialize();
    myCartChangeNotifier.initialize();
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
    homeChangeNotifier.loadRecentlyViewedGuest();

    progressService.hideProgress();
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
  }
}
