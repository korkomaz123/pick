import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/pages/my_cart/widgets/my_cart_shop_counter.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/my_cart_coupon_code.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  PageStyle pageStyle;
  TextEditingController couponCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaAppBar(pageStyle: pageStyle),
      body: SingleChildScrollView(
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
            'My Cart',
            style: boldTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          InkWell(
            onTap: () => null,
            child: Text(
              'Clear cart'.toUpperCase(),
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
            'Total 4 ',
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
          Text(
            'Items',
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
      child: Column(
        children: myCartItems.map((e) => _buildMyCartProduct(e)).toList(),
      ),
    );
  }

  Widget _buildMyCartProduct(CartItemEntity cartItem) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => null,
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
                  cartItem.product.description,
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
                      cartItem.product.price.toString() + ' KD',
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 20),
                    Text(
                      cartItem.product.discount.toString() + ' KD',
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
                  value: cartItem.itemCount,
                  onDecrement: () => cartItem.itemCount > 0
                      ? setState(() {
                          cartItem.itemCount -= 1;
                        })
                      : null,
                  onIncrement: () => setState(() {
                    cartItem.itemCount += 1;
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
                'Products',
                style: boldTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              ),
              Text(
                '2 Items',
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
                'Total',
                style: boldTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              Text(
                '240 KD',
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
        title: 'CHECKOUT',
        titleSize: pageStyle.unitFontSize * 23,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: primaryColor,
        onPressed: () => Navigator.pushNamed(context, Routes.checkoutAddress),
        radius: 0,
      ),
    );
  }
}
