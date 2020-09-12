import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage>
    with TickerProviderStateMixin {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<AnimationController> _slideControllers = [];
  AnimationController _slideController;
  List<AnimationController> _rotationControllers = [];
  AnimationController _rotationController;
  List<AnimationController> _scaleInControllers = [];
  AnimationController _scaleInController;
  List<AnimationController> _scaleOutControllers = [];
  AnimationController _scaleOutController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _rotateAnimation;
  Animation<double> _scaleInAnimation;
  Animation<double> _scaleOutAnimation;

  @override
  void initState() {
    super.initState();

    /// slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticIn,
    ));

    /// rotation animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeIn,
    ));

    /// scaleIn animation controller
    _scaleInController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleInAnimation = Tween<double>(
      begin: 0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _scaleInController,
      curve: Curves.easeIn,
    ));

    /// scaleOut animation controller
    _scaleOutController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleOutAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _scaleOutController,
      curve: Curves.easeIn,
    ));

    /// generate animation controller list
    _slideControllers = List.generate(
      products.length,
      (index) => _slideController,
    );
    _rotationControllers = List.generate(
      products.length,
      (index) => _rotationController,
    );
    _scaleInControllers = List.generate(
      products.length,
      (index) => _scaleInController,
    );
    _scaleOutControllers = List.generate(
      products.length,
      (index) => _scaleOutController,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: AnimatedList(
              key: listKey,
              initialItemCount: products.length,
              itemBuilder: (context, index, _) {
                return Container(
                  width: pageStyle.deviceWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: pageStyle.unitWidth * 10,
                  ),
                  child: Column(
                    children: [
                      WishlistProductCard(
                        pageStyle: pageStyle,
                        product: products[index],
                        onRemoveWishlist: () => _onRemoveWishlist(index),
                        onAddToCart: () => _onAddToCart(index),
                      ),
                      index < (products.length - 1)
                          ? Divider(color: greyColor, thickness: 0.5)
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
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

  void _onRemoveWishlist(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return WishlistRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      _slideControllers[index].forward(from: 0);
      listKey.currentState.removeItem(
        index,
        (context, animation) {
          return SlideTransition(
            position: _offsetAnimation,
            child: Container(
              width: pageStyle.deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
              ),
              child: Column(
                children: [
                  WishlistProductCard(
                    pageStyle: pageStyle,
                    product: products[index],
                    onRemoveWishlist: () => null,
                    onAddToCart: () => null,
                  ),
                  index < (products.length - 1)
                      ? Divider(color: greyColor, thickness: 0.5)
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
        duration: Duration(seconds: 2),
      );
    }
  }

  void _onAddToCart(int index) async {
    _scaleInControllers[index].forward(from: 0);
    _scaleOutControllers[index].forward(from: 0);
    _rotationControllers[index].forward(from: 0);
    listKey.currentState.removeItem(
      index,
      (context, animation) {
        return Container(
          width: pageStyle.deviceWidth,
          height: pageStyle.unitHeight * 260,
          padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
          child: Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: _scaleInAnimation,
                  child: Container(
                    width: pageStyle.deviceWidth,
                    height: pageStyle.unitHeight * 260,
                    child: SvgPicture.asset(
                      shoppingCartIcon,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Center(
                child: ScaleTransition(
                  scale: _scaleOutAnimation,
                  alignment: Alignment.center,
                  child: RotationTransition(
                    turns: _rotateAnimation,
                    child: Container(
                      width: pageStyle.deviceWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: pageStyle.unitWidth * 10,
                      ),
                      child: Column(
                        children: [
                          WishlistProductCard(
                            pageStyle: pageStyle,
                            product: products[index],
                            onRemoveWishlist: () => null,
                            onAddToCart: () => null,
                          ),
                          index < (products.length - 1)
                              ? Divider(color: greyColor, thickness: 0.5)
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      duration: Duration(seconds: 2),
    );
    _showFlashBar(products[index]);
  }

  void _showFlashBar(ProductEntity product) {
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
