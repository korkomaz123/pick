import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/shipping_address_remove_dialog.dart';

class ShippingAddressPage extends StatefulWidget {
  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int defaultAddress;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildAddressList(),
          SizedBox(height: pageStyle.unitHeight * 60),
        ],
      ),
      bottomSheet: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 50,
        margin: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 30,
          vertical: pageStyle.unitHeight * 5,
        ),
        child: MaterialButton(
          onPressed: () => Navigator.pushNamed(context, Routes.editAddress),
          color: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'add_new_address_button_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 21,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'shipping_address_title'.tr(),
        style: boldTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(shippingAddresses.length, (index) {
            return InkWell(
              onTap: () => setState(() {
                defaultAddress = index;
              }),
              child: Container(
                width: pageStyle.deviceWidth,
                height: pageStyle.unitHeight * 190,
                margin: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 10,
                  vertical: pageStyle.unitHeight * 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: pageStyle.unitWidth * 60,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              shippingAddresses[index].country,
                              style: TextStyle(
                                color: greyDarkColor,
                                fontSize: pageStyle.unitFontSize * 14,
                              ),
                            ),
                            SizedBox(height: pageStyle.unitHeight * 10),
                            Text(
                              shippingAddresses[index].city,
                              style: TextStyle(
                                color: greyDarkColor,
                                fontSize: pageStyle.unitFontSize * 14,
                              ),
                            ),
                            SizedBox(height: pageStyle.unitHeight * 10),
                            Text(
                              shippingAddresses[index].street,
                              style: TextStyle(
                                color: greyDarkColor,
                                fontSize: pageStyle.unitFontSize * 14,
                              ),
                            ),
                            SizedBox(height: pageStyle.unitHeight * 10),
                            Text(
                              shippingAddresses[index].phoneNumber,
                              style: TextStyle(
                                color: greyDarkColor,
                                fontSize: pageStyle.unitFontSize * 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Radio(
                        value: index,
                        groupValue: defaultAddress,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          defaultAddress = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: SvgPicture.asset(editIcon),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          Routes.editAddress,
                          arguments: shippingAddresses[index],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: SvgPicture.asset(trashIcon),
                        onPressed: () => _onRemove(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _onRemove() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ShippingAddressRemoveDialog(pageStyle: pageStyle);
      },
    );
  }
}
