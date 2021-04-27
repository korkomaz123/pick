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
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';

import 'logout_confirm_dialog.dart';

class LogoutItem extends StatefulWidget {
  final PageStyle pageStyle;
  final SnackBarService snackBarService;
  final ProgressService progressService;

  LogoutItem({this.pageStyle, this.snackBarService, this.progressService});

  @override
  _LogoutItemState createState() => _LogoutItemState();
}

class _LogoutItemState extends State<LogoutItem> {
  PageStyle pageStyle;
  SnackBarService snackBarService;
  ProgressService progressService;
  SignInBloc signInBloc;
  final LocalStorageRepository localRepo = LocalStorageRepository();
  SettingRepository settingRepo = SettingRepository();
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    snackBarService = widget.snackBarService;
    progressService = widget.progressService;
    signInBloc = context.read<SignInBloc>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
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
            padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: pageStyle.unitWidth * 22,
                      height: pageStyle.unitHeight * 22,
                      child: SvgPicture.asset(logoutIcon),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 10),
                    Text(
                      'account_logout'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: pageStyle.unitFontSize * 20,
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
        return LogoutConfirmDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      signInBloc.add(SignOutSubmitted(token: user.token));
    }
  }

  void _logoutUser() async {
    await settingRepo.updateFcmDeviceToken(user.token, '', '', lang, lang);
    user = null;
    await localRepo.setToken('');
    myCartChangeNotifier.initialize();
    await myCartChangeNotifier.getCartId();
    wishlistChangeNotifier.initialize();
    orderChangeNotifier.initializeOrders();
    progressService.hideProgress();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }
}
