import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/markaa_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:markaa/src/pages/markaa_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_repository.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

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
  CartItemCountBloc cartItemCountBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;
  SettingRepository settingRepo;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    snackBarService = widget.snackBarService;
    progressService = widget.progressService;
    signInBloc = context.read<SignInBloc>();
    cartItemCountBloc = context.read<CartItemCountBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    settingRepo = context.read<SettingRepository>();
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
    await settingRepo.updateFcmDeviceToken(user.token, '', '');
    user = null;
    await localRepo.setToken('');
    myCartItems.clear();
    cartTotalPrice = .0;
    cartItemCountBloc.add(CartItemCountSet(cartItemCount: 0));
    wishlistItemCountBloc.add(WishlistItemCountSet(wishlistItemCount: 0));
    await _loadViewerCartItems();
    progressService.hideProgress();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  Future<void> _loadViewerCartItems() async {
    final cartId = await localRepo.getCartId();
    if (cartId.isNotEmpty) {
      print('/// logged out ///');
      print('/// cartId: $cartId ///');
      final result = await cartRepo.getCartItems(cartId, lang);
      if (result['code'] == 'SUCCESS') {
        print('/// get cart item ///');
        List<dynamic> cartList = result['cart'];
        int count = 0;
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] =
              ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['itemCount'] = cartList[i]['itemCount'];
          cartItemJson['itemId'] = cartList[i]['itemid'];
          cartItemJson['rowPrice'] = cartList[i]['row_price'];
          cartItemJson['availableCount'] = cartList[i]['availableCount'];
          CartItemEntity cart = CartItemEntity.fromJson(cartItemJson);
          myCartItems.add(cart);
          count += cart.itemCount;
          cartTotalPrice +=
              cart.itemCount * double.parse(cart.product.price).ceil();
        }
        cartItemCount = count;
        cartItemCountBloc.add(CartItemCountSet(cartItemCount: count));
      }
    }
  }
}
