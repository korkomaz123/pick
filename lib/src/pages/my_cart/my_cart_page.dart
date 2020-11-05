import 'dart:async';

import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/pages/my_cart/widgets/my_cart_remove_dialog.dart';
import 'package:ciga/src/pages/my_cart/widgets/my_cart_shop_counter.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/animation_durations.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:lottie/lottie.dart';

import 'widgets/my_cart_coupon_code.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage>
    with SingleTickerProviderStateMixin {
  PageStyle pageStyle;
  TextEditingController couponCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCartPage: true,
      ),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildTitleBar(),
                _buildTotalItemsTitle(),
                _buildTotalItems(),
                MyCartCouponCode(
                  pageStyle: pageStyle,
                  controller: couponCodeController,
                ),
                _buildTotalPrice(),
                _buildCheckoutButton(),
              ],
            ),
          ),
          isDeleting
              ? Material(
                  color: Colors.black.withOpacity(0),
                  child: Center(
                    child: Lottie.asset(
                      'lib/public/animations/trash-clean.json',
                      width: pageStyle.unitWidth * 100,
                      height: pageStyle.unitHeight * 100,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'my_cart_title'.tr(),
            style: boldTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          InkWell(
            onTap: () => setState(() {
              myCartItems.clear();
            }),
            child: Text(
              'my_cart_clear_cart'.tr(),
              style: bookTextStyle.copyWith(
                color: dangerColor,
                fontSize: pageStyle.unitFontSize * 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItemsTitle() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Row(
        children: [
          Text(
            'total'.tr() + ' ${myCartItems.length} ',
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
          Text(
            'items'.tr(),
            style: bookTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItems() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: AnimationLimiter(
        child: Column(
          children: List.generate(
            myCartItems.length,
            (index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(seconds: 1),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      children: [
                        _buildMyCartProduct(index),
                        index < (myCartItems.length - 1)
                            ? Divider(color: greyColor, thickness: 0.5)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMyCartProduct(int index) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onRemoveCartItem(index),
            child: Icon(
              Icons.remove_circle_outline,
              size: pageStyle.unitFontSize * 22,
              color: greyDarkColor,
            ),
          ),
          Image.asset(
            'lib/public/images/shutterstock_151558448-1.png',
            width: pageStyle.unitWidth * 134,
            height: pageStyle.unitHeight * 150,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jazzia Group',
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 10,
                  ),
                ),
                Text(
                  myCartItems[index].product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      myCartItems[index].product.price.toString() +
                          ' ' +
                          'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 20),
                    Text(
                      myCartItems[index].product.price.toString() +
                          ' ' +
                          'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: dangerColor,
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pageStyle.unitHeight * 10),
                MyCartShopCounter(
                  pageStyle: pageStyle,
                  value: myCartItems[index].itemCount,
                  onDecrement: () => myCartItems[index].itemCount > 0
                      ? setState(() {
                          myCartItems[index].itemCount -= 1;
                        })
                      : null,
                  onIncrement: () => setState(() {
                    myCartItems[index].itemCount += 1;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 6,
      ),
      decoration: BoxDecoration(
        color: greyLightColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'products'.tr(),
                style: boldTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              ),
              Text(
                '2 ' + 'items'.tr(),
                style: boldTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              )
            ],
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: boldTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              Text(
                '240 ' + 'currency'.tr(),
                style: boldTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 18,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 80,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: TextButton(
        title: 'checkout_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 23,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: primarySwatchColor,
        onPressed: () => Navigator.pushNamed(context, Routes.checkoutAddress),
        radius: 0,
      ),
    );
  }

  void _onRemoveCartItem(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return MyCartRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      isDeleting = true;
      setState(() {});
      Timer.periodic(
        AnimationDurations.removeItemAniDuration,
        (timer) {
          timer.cancel();
          isDeleting = false;
          setState(() {});
        },
      );
    }
  }
}
