import 'dart:async';

import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/no_available_data.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:ciga/src/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:ciga/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/animation_durations.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.watch<MyCartBloc>(),
      child: WishlistPageView(),
    );
  }
}

class WishlistPageView extends StatefulWidget {
  @override
  _WishlistPageViewState createState() => _WishlistPageViewState();
}

class _WishlistPageViewState extends State<WishlistPageView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool isDeleting = false;
  bool isAdding = false;
  List<ProductModel> wishlists = [];
  List<String> ids = [];
  int selectedIndex;
  String cartId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  WishlistBloc wishlistBloc;
  MyCartBloc cartBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  LocalStorageRepository localStorageRepo;

  @override
  void initState() {
    super.initState();
    localStorageRepo = context.read<LocalStorageRepository>();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    flushBarService = FlushBarService(context: context);
    wishlistBloc = context.read<WishlistBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    cartBloc = context.read<MyCartBloc>();
    _triggerLoadWishlistEvent();
    _getCartId();
  }

  @override
  void dispose() {
    wishlistBloc.add(WishlistInitialized());
    super.dispose();
  }

  void _triggerLoadWishlistEvent() async {
    String token = await localStorageRepo.getToken();
    ids = await localStorageRepo.getWishlistIds();
    if (ids.isNotEmpty) {
      wishlistBloc.add(WishlistLoaded(ids: ids, token: token, lang: lang));
    }
  }

  void _getCartId() async {
    cartId = await localStorageRepo.getCartId();
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
              BlocListener<MyCartBloc, MyCartState>(
                listener: (context, state) {
                  if (state is MyCartCreatedFailure) {
                    flushBarService.showErrorMessage(
                      pageStyle,
                      state.message,
                    );
                  }
                  if (state is MyCartItemAddedSuccess) {
                    _onRemoveWishlist(selectedIndex, false);
                    flushBarService.showAddCartMessage(
                      pageStyle,
                      state.product,
                    );
                  }
                  if (state is MyCartItemAddedFailure) {
                    flushBarService.showErrorMessage(
                      pageStyle,
                      state.message,
                    );
                  }
                },
                child: BlocConsumer<WishlistBloc, WishlistState>(
                  listener: (context, state) {
                    // if (state is WishlistLoadedInProcess) {
                    //   progressService.showProgress();
                    // }
                    if (state is WishlistLoadedFailure) {
                      // progressService.hideProgress();
                      snackBarService.showErrorSnackBar(state.message);
                    }
                    // if (state is WishlistLoadedSuccess) {
                    //   progressService.hideProgress();
                    // }
                  },
                  builder: (context, state) {
                    if (state is WishlistLoadedSuccess) {
                      wishlists = state.wishlists;
                    }
                    return ids.isNotEmpty
                        ? _buildWishlistItems()
                        : Expanded(
                            child: NoAvailableData(
                              pageStyle: pageStyle,
                              message: 'wishlist_empty',
                            ),
                          );
                  },
                ),
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
                    onRemoveWishlist: () => _onRemoveWishlist(index, true),
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

  void _onRemoveWishlist(int index, bool ask) async {
    var result;
    if (ask) {
      result = await showDialog(
        context: context,
        builder: (context) {
          return WishlistRemoveDialog(pageStyle: pageStyle);
        },
      );
    }
    if (result != null || !ask) {
      await localStorageRepo.removeWishlistItem(ids[index]);
      ids.removeAt(index);
      wishlistItemCountBloc.add(WishlistItemCountSet(
        wishlistItemCount: ids.length,
      ));
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
    selectedIndex = index;
    if (cartId.isEmpty) {
      cartBloc.add(MyCartCreated(
        product: wishlists[index],
      ));
    } else {
      cartBloc.add(MyCartItemAdded(
        cartId: cartId,
        product: wishlists[index],
        qty: '1',
      ));
    }
  }
}
