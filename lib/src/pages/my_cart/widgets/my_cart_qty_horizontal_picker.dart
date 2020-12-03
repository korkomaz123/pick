import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartQtyHorizontalPicker extends StatefulWidget {
  final PageStyle pageStyle;
  final int qty;

  MyCartQtyHorizontalPicker({this.pageStyle, this.qty});

  @override
  _MyCartQtyHorizontalPickerState createState() =>
      _MyCartQtyHorizontalPickerState();
}

class _MyCartQtyHorizontalPickerState extends State<MyCartQtyHorizontalPicker> {
  PageStyle pageStyle;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onChangeQty(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 6,
          vertical: pageStyle.unitHeight * 5,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              widget.qty.toString() + ' QTY',
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
        return QtyDropdownDialog(pageStyle: pageStyle);
      },
    );
  }
}

class QtyDropdownDialog extends StatefulWidget {
  final PageStyle pageStyle;

  QtyDropdownDialog({this.pageStyle});

  @override
  _QtyDropdownDialogState createState() => _QtyDropdownDialogState();
}

class _QtyDropdownDialogState extends State<QtyDropdownDialog> {
  @override
  Widget build(BuildContext context) {
    double topPadding =
        widget.pageStyle.appBarHeight + widget.pageStyle.unitHeight * 60;
    double bottomPadding = widget.pageStyle.unitHeight * 60;
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Material(
        color: Colors.white.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.pageStyle.deviceWidth,
              height: widget.pageStyle.unitHeight * 95,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: widget.pageStyle.deviceWidth,
                      color: primarySwatchColor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            10,
                            (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: widget.pageStyle.unitWidth * 10,
                                  vertical: widget.pageStyle.unitHeight * 10,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.pageStyle.unitWidth * 15,
                                  vertical: widget.pageStyle.unitHeight * 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  (10 - index).toString(),
                                  style: mediumTextStyle.copyWith(
                                    fontSize:
                                        widget.pageStyle.unitFontSize * 16,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
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
}
