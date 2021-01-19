import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/markaa_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:markaa/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
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
  int selectedIndex;
  String cartId;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  WishlistBloc wishlistBloc;
  MyCartBloc cartBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  MyCartRepository cartRepo;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    flushBarService = FlushBarService(context: context);
    wishlistBloc = context.read<WishlistBloc>();
    wishlistBloc.add(WishlistLoaded(token: user.token, lang: lang));
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    cartBloc = context.read<MyCartBloc>();
    cartRepo = context.read<MyCartRepository>();
    _getCartId();
  }

  @override
  void dispose() {
    wishlistBloc.add(WishlistInitialized());
    super.dispose();
  }

  void _getCartId() async {
    final result = await cartRepo.getCartId(user.token);
    if (result['code'] == 'SUCCESS') {
      cartId = result['cartId'];
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
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
                    if (state is WishlistLoadedSuccess) {
                      wishlistItemCountBloc.add(WishlistItemCountSet(
                        wishlistItemCount: state.wishlists.length,
                      ));
                    }
                    if (state is WishlistLoadedFailure) {
                      flushBarService.showErrorMessage(
                          pageStyle, state.message);
                    }
                    if (state is WishlistAddedInProcess) {
                      progressService.showProgress();
                    }
                    if (state is WishlistAddedFailure) {
                      progressService.hideProgress();
                      flushBarService.showErrorMessage(
                          pageStyle, state.message);
                    }
                    if (state is WishlistRemovedInProcess) {
                      progressService.showProgress();
                    }
                    if (state is WishlistRemovedFailure) {
                      progressService.hideProgress();
                      flushBarService.showErrorMessage(
                          pageStyle, state.message);
                    }
                    if (state is WishlistAddedSuccess) {
                      progressService.hideProgress();
                      wishlistBloc.add(WishlistLoaded(
                        token: user.token,
                        lang: lang,
                      ));
                    }
                    if (state is WishlistRemovedSuccess) {
                      progressService.hideProgress();
                      wishlistBloc.add(WishlistLoaded(
                        token: user.token,
                        lang: lang,
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is WishlistLoadedSuccess) {
                      wishlists = state.wishlists;
                    }
                    return wishlists.isEmpty && state is WishlistLoadedSuccess
                        ? Expanded(
                            child: NoAvailableData(
                              pageStyle: pageStyle,
                              message: 'wishlist_empty',
                            ),
                          )
                        : _buildWishlistItems();
                  },
                ),
              ),
            ],
          ),
          _buildLottieAnimationOnDelete(),
          _buildLottieAnimationOnAdd(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.wishlist,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 40,
      color: primarySwatchColor,
      padding: EdgeInsets.only(
        left: pageStyle.unitWidth * 10,
        right: pageStyle.unitWidth * 10,
        bottom: pageStyle.unitHeight * 10,
      ),
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
            style: mediumTextStyle.copyWith(
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
      wishlistItemCountBloc.add(WishlistItemCountSet(
        wishlistItemCount: wishlists.length,
      ));
      wishlistBloc.add(WishlistRemoved(
        token: user.token,
        productId: wishlists[index].entityId,
      ));
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
