import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/ciga_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/pages/my_account/widgets/logout_confirm_dialog.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaSideMenu extends StatefulWidget {
  final PageStyle pageStyle;

  CigaSideMenu({this.pageStyle});

  @override
  _CigaSideMenuState createState() => _CigaSideMenuState();
}

class _CigaSideMenuState extends State<CigaSideMenu> {
  PageStyle pageStyle;
  double menuWidth;
  String activeMenu = '';
  HomeBloc homeBloc;
  SignInBloc signInBloc;
  CartItemCountBloc cartItemCountBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  ProgressService progressService;
  FlushBarService flushBarService;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    homeBloc = context.read<HomeBloc>();
    signInBloc = context.read<SignInBloc>();
    cartItemCountBloc = context.read<CartItemCountBloc>();
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    menuWidth = pageStyle.unitWidth * 300;
    return Container(
      width: menuWidth,
      height: pageStyle.deviceHeight,
      color: Colors.white,
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignOutSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is SignOutSubmittedSuccess) {
            progressService.hideProgress();
            _logoutUser();
          }
          if (state is SignOutSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildMenuHeader(),
                _buildMenuItems(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      width: menuWidth,
      height: pageStyle.unitHeight * 160,
      color: primarySwatchColor,
      child: Stack(
        children: [
          _buildHeaderLogo(),
          _buildHeaderAuth(),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: pageStyle.unitHeight * 40),
        child: user != null
            ? Row(
                children: [
                  Container(
                    width: pageStyle.unitWidth * 60,
                    height: pageStyle.unitWidth * 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: user.profileUrl.isNotEmpty
                            ? NetworkImage(user.profileUrl)
                            : AssetImage('lib/public/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: pageStyle.unitWidth * 10),
                  Text(
                    'Hello, ' + user?.firstName,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: pageStyle.unitHeight * 5),
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: pageStyle.unitWidth * 95,
                  height: pageStyle.unitHeight * 35,
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderAuth() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => user != null ? _logout() : _login(),
        child: Container(
          padding: EdgeInsets.only(
            left: pageStyle.unitWidth * 30,
            right: pageStyle.unitWidth * 30,
            bottom: pageStyle.unitHeight * 10,
          ),
          width: double.infinity,
          child: Row(
            children: [
              SvgPicture.asset(
                sideLoginIcon,
                height: pageStyle.unitHeight * 15,
              ),
              SizedBox(width: pageStyle.unitWidth * 4),
              Text(
                user != null ? 'logout'.tr() : 'login'.tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      child: Column(
        children: sideMenus.map((menu) {
          // int index = sideMenus.indexOf(menu);
          // int length = sideMenus.length;
          return Column(
            children: [
              _buildParentMenu(menu),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 4,
                ),
                child: Divider(
                  color: Colors.grey.shade400,
                  height: pageStyle.unitHeight * 1,
                ),
              ),
              activeMenu == menu.id ? _buildSubmenu(menu) : SizedBox.shrink(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParentMenu(CategoryMenuEntity menu) {
    return InkWell(
      onTap: () => menu.subMenu.isNotEmpty
          ? _displaySubmenu(menu)
          : _viewCategory(menu, 0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: pageStyle.unitHeight * 15),
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 20,
          vertical: pageStyle.unitHeight * 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                menu.iconUrl.isNotEmpty
                    ? Row(
                        children: [
                          Image.network(menu.iconUrl, width: 25, height: 25),
                          SizedBox(width: 6),
                        ],
                      )
                    : SizedBox.shrink(),
                Text(
                  menu.title.toUpperCase(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 14,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            menu.subMenu.isNotEmpty
                ? Icon(
                    activeMenu == menu.id
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right,
                    size: pageStyle.unitFontSize * 25,
                    color: greyDarkColor,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(CategoryMenuEntity menu) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(
          menu.subMenu.length,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 200),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () => _viewCategory(menu, index),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: pageStyle.unitWidth * 40,
                      vertical: pageStyle.unitHeight * 10,
                    ),
                    child: Text(
                      menu.subMenu[index].title,
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 14,
                        color: darkColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _displaySubmenu(CategoryMenuEntity menu) {
    if (activeMenu == menu.id) {
      activeMenu = '';
    } else {
      activeMenu = menu.id;
    }
    setState(() {});
  }

  void _viewCategory(CategoryMenuEntity parentMenu, int index) {
    ProductListArguments arguments = ProductListArguments(
      category: CategoryEntity(id: parentMenu.id, name: parentMenu.title),
      brand: BrandEntity(),
      subCategory: [],
      selectedSubCategoryIndex: index + 1,
      isFromBrand: false,
    );
    Navigator.popAndPushNamed(
      context,
      Routes.productList,
      arguments: arguments,
    );
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    Navigator.pop(context);
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
    user = null;
    await localRepo.setToken('');
    List<String> ids = await localRepo.getRecentlyViewedIds();
    myCartItems.clear();
    cartItemCountBloc.add(CartItemCountSet(cartItemCount: 0));
    wishlistItemCountBloc.add(WishlistItemCountSet(wishlistItemCount: 0));
    await _loadViewerCartItems();
    homeBloc.add(HomeRecentlyViewedGuestLoaded(ids: ids, lang: lang));
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
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
