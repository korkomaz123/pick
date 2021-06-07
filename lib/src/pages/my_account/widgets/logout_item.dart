import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
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
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';

import '../../../../preload.dart';
import 'logout_confirm_dialog.dart';

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

  SignInBloc signInBloc;
  final LocalStorageRepository localRepo = LocalStorageRepository();
  SettingRepository settingRepo = SettingRepository();
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    snackBarService = widget.snackBarService;
    progressService = widget.progressService;
    signInBloc = context.read<SignInBloc>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignOutSubmittedInProcess) {
          progressService.showProgress();
        }
        if (state is SignOutSubmittedSuccess) {
          _logoutUser();
        }
        if (state is SignOutSubmittedFailure) {
          progressService.hideProgress();
          snackBarService.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
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
                      child: SvgPicture.asset(logoutIcon),
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
      },
    );
  }

  void _logout() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return LogoutConfirmDialog();
      },
    );
    if (result != null) {
      signInBloc.add(SignOutSubmitted(token: user.token));
    }
  }

  void _logoutUser() async {
    await localRepo.setToken('');
    await settingRepo.updateFcmDeviceToken(user.token, '', '', lang, lang);
    user = null;

    orderChangeNotifier.initializeOrders();
    wishlistChangeNotifier.initialize();

    myCartChangeNotifier.initialize();
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);

    homeChangeNotifier.loadRecentlyViewedGuest();

    progressService.hideProgress();

    Navigator.pop(Preload.navigatorKey.currentContext);
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
  }
}
