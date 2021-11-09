import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class MyCartQtyHorizontalPicker extends StatefulWidget {
  final CartItemEntity cartItem;
  final String cartId;
  final void Function()? onChange;
  final bool isDefaultValue;

  MyCartQtyHorizontalPicker({
    required this.cartItem,
    required this.cartId,
    this.onChange,
    this.isDefaultValue = true,
  });

  @override
  _MyCartQtyHorizontalPickerState createState() =>
      _MyCartQtyHorizontalPickerState();
}

class _MyCartQtyHorizontalPickerState extends State<MyCartQtyHorizontalPicker> {
  MyCartChangeNotifier? myCartChangeNotifier;
  FlushBarService? flushBarService;

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.cartItem.availableCount > 0
          ? widget.onChange ?? _onChangeQty
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: widget.cartItem.availableCount > 0 ? primaryColor : greyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              widget.isDefaultValue && widget.cartItem.availableCount > 0
                  ? (widget.cartItem.itemCount.toString() + ' ' + 'qty'.tr())
                  : 'select_quantity'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 8.sp,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeQty() async {
    final result = await showDialog(
      barrierColor: Colors.white.withOpacity(0.0000000001),
      context: context,
      builder: (context) {
        return QtyDropdownDialog(
          cartItem: widget.cartItem,
        );
      },
    );
    if (result != null) {
      await myCartChangeNotifier!
          .updateCartItem(widget.cartItem, result, _onFailure);
    }
  }

  void _onFailure(String message) {
    flushBarService!.showErrorDialog(message);
  }
}

class QtyDropdownDialog extends StatefulWidget {
  final CartItemEntity cartItem;

  QtyDropdownDialog({required this.cartItem});

  @override
  _QtyDropdownDialogState createState() => _QtyDropdownDialogState();
}

class _QtyDropdownDialogState extends State<QtyDropdownDialog> {
  int? availableCount;
  String? productId;

  @override
  void initState() {
    super.initState();
    availableCount = widget.cartItem.availableCount > 20
        ? 20
        : widget.cartItem.availableCount;
    productId = widget.cartItem.product.productId;
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = 120.h;
    double bottomPadding = 60.h;
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Material(
        color: Colors.white.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 375.w,
              height: 95.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 375.w,
                      color: primarySwatchColor,
                      height: 60,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            availableCount!,
                            (index) => _buildQtyItem(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (lang == 'en') ...[
                    Positioned(
                      bottom: 45.h,
                      right: 0,
                      child: IconButton(
                        icon: SvgPicture.asset('lib/public/icons/close.svg'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ] else ...[
                    Positioned(
                      bottom: 45.h,
                      left: 0,
                      child: IconButton(
                        icon: SvgPicture.asset('lib/public/icons/close.svg'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyItem(int index) {
    return InkWell(
      onTap: () => Navigator.pop(context, availableCount! - index),
      child: Container(
        width: 45.h,
        height: 45.h,
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          (availableCount! - index).toString(),
          textAlign: TextAlign.center,
          style: mediumTextStyle.copyWith(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
