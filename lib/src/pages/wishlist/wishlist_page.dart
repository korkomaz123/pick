import 'dart:async';

import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:ciga/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/animation_durations.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  LocalStorageRepository localStorageRepo;
  bool isDeleting = false;
  bool isAdding = false;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  WishlistBloc wishlistBloc;
  List<ProductModel> wishlists = [];
  List<String> ids = [];

  @override
  void initState() {
    super.initState();
    localStorageRepo = context.repository<LocalStorageRepository>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    wishlistBloc = context.bloc<WishlistBloc>();
    _triggerLoadWishlistEvent();
  }

  void _triggerLoadWishlistEvent() async {
    String token = await localStorageRepo.getToken();
    ids = await localStorageRepo.getWishlistIds();
    if (ids.isNotEmpty) {
      wishlistBloc.add(WishlistLoaded(ids: ids, token: token));
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              BlocConsumer<WishlistBloc, WishlistState>(
                listener: (context, state) {
                  if (state is WishlistLoadedInProcess) {
                    progressService.showProgress();
                  }
                  if (state is WishlistLoadedFailure) {
                    progressService.hideProgress();
                    snackBarService.showErrorSnackBar(state.message);
                  }
                  if (state is WishlistLoadedSuccess) {
                    progressService.hideProgress();
                  }
                },
                builder: (context, state) {
                  if (state is WishlistLoadedSuccess) {
                    wishlists = state.wishlists;
                    return _buildWishlistItems();
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          _buildLottieAnimationOnDelete(),
          _buildLottieAnimationOnAdd(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.wishlist,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      color: primarySwatchColor,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: pageStyle.unitFontSize * 20,
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'account_wishlist_title'.tr(),
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    return Expanded(
      child: ListView.builder(
        itemCount: wishlists.length,
        itemBuilder: (context, index) {
          return Container(
            width: pageStyle.deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: wishlists[index],
                  ),
                  child: WishlistProductCard(
                    pageStyle: pageStyle,
                    product: wishlists[index],
                    onRemoveWishlist: () => _onRemoveWishlist(index),
                    onAddToCart: () => _onAddToCart(index),
                  ),
                ),
                index < (wishlists.length - 1)
                    ? Divider(color: greyColor, thickness: 0.5)
                    : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLottieAnimationOnDelete() {
    return isDeleting
        ? Material(
            color: Colors.black.withOpacity(0),
            child: Center(
              child: Lottie.asset(
                'lib/public/animations/heart-break.json',
                width: pageStyle.unitWidth * 100,
                height: pageStyle.unitHeight * 100,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildLottieAnimationOnAdd() {
    return isAdding
        ? Material(
            color: Colors.black.withOpacity(0),
            child: Center(
              child: Lottie.asset(
                'lib/public/animations/add-to-cart-shopping.json',
                width: pageStyle.unitWidth * 200,
                height: pageStyle.unitHeight * 200,
              ),
            ),
          )
        : SizedBox.shrink();
  }

  void _onRemoveWishlist(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return WishlistRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      await localStorageRepo.removeWishlistItem(ids[index]);
      ids.removeAt(index);
      Timer.periodic(
        AnimationDurations.removeFavoriteItemAniDuration,
        (timer) {
          timer.cancel();
          isDeleting = false;
          wishlists.removeAt(index);
          setState(() {});
        },
      );
      isDeleting = true;
      setState(() {});
    }
  }

  void _onAddToCart(int index) async {
    isAdding = true;
    setState(() {});
    Timer.periodic(
      AnimationDurations.addToCartAniDuration,
      (timer) {
        timer.cancel();
        isAdding = false;
        setState(() {});
      },
    );
    listKey.currentState.removeItem(
      index,
      (context, animation) {
        return Container(
          width: pageStyle.deviceWidth,
          height: pageStyle.unitHeight * 260,
          padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
          child: Container(
            width: pageStyle.deviceWidth,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            child: Column(
              children: [
                WishlistProductCard(
                  pageStyle: pageStyle,
                  product: wishlists[index],
                  onRemoveWishlist: () => null,
                  onAddToCart: () => null,
                ),
                index < (wishlists.length - 1)
                    ? Divider(color: greyColor, thickness: 0.5)
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
      duration: Duration(seconds: 2),
    );
    _showFlashBar(wishlists[index]);
  }

  void _showFlashBar(ProductModel product) {
    Flushbar(
      messageText: Container(
        width: pageStyle.unitWidth * 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 15,
                  ),
                ),
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cart Total',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
                Text(
                  'KD 460',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: pageStyle.unitWidth * 20,
        height: pageStyle.unitHeight * 20,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[100],
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: primaryColor,
    )..show(context);
  }
}
