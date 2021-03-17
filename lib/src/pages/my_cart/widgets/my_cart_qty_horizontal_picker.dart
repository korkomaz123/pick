import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class MyCartQtyHorizontalPicker extends StatefulWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;
  final String cartId;
  final Function onChange;
  final bool isDefaultValue;

  MyCartQtyHorizontalPicker({
    this.pageStyle,
    this.cartItem,
    this.cartId,
    this.onChange,
    this.isDefaultValue = true,
  });

  @override
  _MyCartQtyHorizontalPickerState createState() =>
      _MyCartQtyHorizontalPickerState();
}

class _MyCartQtyHorizontalPickerState extends State<MyCartQtyHorizontalPicker> {
  PageStyle pageStyle;
  MyCartChangeNotifier myCartChangeNotifier;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.cartItem.availableCount > 0
          ? (widget.onChange ?? () => _onChangeQty())
          : () => null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 6,
          vertical: pageStyle.unitHeight * 5,
        ),
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
                fontSize: pageStyle.unitFontSize * 8,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: pageStyle.unitFontSize * 16,
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
          pageStyle: pageStyle,
          cartItem: widget.cartItem,
        );
      },
    );
    if (result != null) {
      await myCartChangeNotifier.updateCartItem(
          widget.cartItem, result, _onFailure);
    }
  }

  void _onFailure(String message) {
    flushBarService.showErrorMessage(widget.pageStyle, message);
  }
}

class QtyDropdownDialog extends StatefulWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;

  QtyDropdownDialog({this.pageStyle, this.cartItem});

  @override
  _QtyDropdownDialogState createState() => _QtyDropdownDialogState();
}

class _QtyDropdownDialogState extends State<QtyDropdownDialog> {
  int availableCount;
  String productId;
  PageStyle pageStyle;

  @override
  void initState() {
    super.initState();
    availableCount = widget.cartItem.availableCount > 20
        ? 20
        : widget.cartItem.availableCount;
    pageStyle = widget.pageStyle;
    productId = widget.cartItem.product.productId;
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = pageStyle.appBarHeight + pageStyle.unitHeight * 60;
    double bottomPadding = pageStyle.unitHeight * 60;
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Material(
        color: Colors.white.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: pageStyle.deviceWidth,
              height: pageStyle.unitHeight * 95,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: pageStyle.deviceWidth,
                      color: primarySwatchColor,
                      height: 60,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            availableCount,
                            (index) => _buildQtyItem(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (lang == 'en') ...[
                    Positioned(
                      bottom: pageStyle.unitHeight * 45,
                      right: 0,
                      child: IconButton(
                        icon: SvgPicture.asset('lib/public/icons/close.svg'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ] else ...[
                    Positioned(
                      bottom: pageStyle.unitHeight * 45,
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
      onTap: () => Navigator.pop(
        context,
        availableCount - index,
      ),
      child: Container(
        width: pageStyle.unitHeight * 45,
        height: pageStyle.unitHeight * 45,
        margin: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          (availableCount - index).toString(),
          textAlign: TextAlign.center,
          style: mediumTextStyle.copyWith(
            fontSize: widget.pageStyle.unitFontSize * 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
