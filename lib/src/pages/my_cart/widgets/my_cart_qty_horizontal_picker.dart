import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

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
  MyCartBloc myCartBloc;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    myCartBloc = context.read<MyCartBloc>();
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
    print(widget.cartItem.availableCount);
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
      myCartBloc.add(MyCartItemUpdated(
        cartId: widget.cartId,
        itemId: widget.cartItem.itemId,
        qty: result.toString(),
      ));
    }
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
  MyCartRepository myCartRepo;

  @override
  void initState() {
    super.initState();
    myCartRepo = context.read<MyCartRepository>();
    availableCount = 0;
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: pageStyle.deviceWidth,
              height: pageStyle.unitHeight * 95,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: pageStyle.deviceWidth,
                      color: primarySwatchColor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            widget.cartItem.availableCount,
                            (index) => _buildQtyItem(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: SvgPicture.asset('lib/public/icons/close.svg'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
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
        widget.cartItem.availableCount - index,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 10,
          vertical: widget.pageStyle.unitHeight * 10,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 15,
          vertical: widget.pageStyle.unitHeight * 6,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          (widget.cartItem.availableCount - index).toString(),
          style: mediumTextStyle.copyWith(
            fontSize: widget.pageStyle.unitFontSize * 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
