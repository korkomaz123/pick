import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class MyCartShopCounter extends StatefulWidget {
  final CartItemEntity cartItem;
  final String cartId;
  final bool isDefaultValue;

  MyCartShopCounter({
    @required this.cartItem,
    @required this.cartId,
    this.isDefaultValue = true,
  });

  @override
  _MyCartShopCounterState createState() => _MyCartShopCounterState();
}

class _MyCartShopCounterState extends State<MyCartShopCounter> {
  MyCartChangeNotifier myCartChangeNotifier;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkaaAppChangeNotifier>(
      builder: (_, model, __) {
        return Row(
          children: [
            InkWell(
              onTap: () => widget.cartItem.itemCount == 1
                  ? null
                  : _onChangeQty(false, model),
              child: Container(
                height: 25.h,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: widget.cartItem.itemCount == 1
                        ? Colors.grey.shade400
                        : greyColor,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(lang == 'ar' ? 10 : 0),
                    bottomRight: Radius.circular(lang == 'ar' ? 10 : 0),
                    topLeft: Radius.circular(lang == 'en' ? 10 : 0),
                    bottomLeft: Radius.circular(lang == 'en' ? 10 : 0),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: 18.sp,
                  color: widget.cartItem.itemCount == 1
                      ? Colors.grey.shade400
                      : primaryColor,
                ),
              ),
            ),
            Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: greyColor),
                  bottom: BorderSide(color: greyColor),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.cartItem.itemCount.toString(),
                style: mediumTextStyle.copyWith(
                  color: primarySwatchColor,
                  fontSize: 15.sp,
                ),
              ),
            ),
            InkWell(
              onTap: () =>
                  widget.cartItem.itemCount == widget.cartItem.availableCount
                      ? null
                      : _onChangeQty(true, model),
              child: Container(
                height: 25.h,
                padding: EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: widget.cartItem.itemCount ==
                            widget.cartItem.availableCount
                        ? Colors.grey.shade400
                        : greyColor,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(lang == 'en' ? 10 : 0),
                    bottomRight: Radius.circular(lang == 'en' ? 10 : 0),
                    topLeft: Radius.circular(lang == 'ar' ? 10 : 0),
                    bottomLeft: Radius.circular(lang == 'ar' ? 10 : 0),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 18.sp,
                  color: widget.cartItem.itemCount ==
                          widget.cartItem.availableCount
                      ? Colors.grey.shade400
                      : primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onChangeQty(bool isIncreament, MarkaaAppChangeNotifier model) async {
    if (model.activeUpdateCart) {
      // model.changeUpdateCartStatus(false);
      int qty = widget.cartItem.itemCount + (isIncreament ? 1 : -1);
      await myCartChangeNotifier.updateCartItem(
          widget.cartItem, qty, _onFailure);
      // model.changeUpdateCartStatus(true);
    }
  }

  void _onFailure(String message) {
    flushBarService.showErrorMessage(message);
  }
}
