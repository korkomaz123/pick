import 'package:flutter/material.dart';

class MarkaaSelectOption extends StatefulWidget {
  /// items of radio buttons
  final List items;

  /// value of selected item
  final String? value;

  /// values of selected item multiple
  final List? values;

  /// width of each item
  final double itemWidth;

  /// height of item
  final double itemHeight;

  /// space between items
  final double itemSpace;

  /// font size of title
  final double titleSize;

  /// border radius
  final double radius;

  /// selected item's background color
  final Color selectedColor;

  /// unselected item's background color
  final Color unSelectedColor;

  /// selected title color
  final Color selectedTitleColor;

  /// unselected title color
  final Color unSelectedTitleColor;

  /// selected border color
  final Color selectedBorderColor;

  /// unselected border color
  final Color unSelectedBorderColor;

  /// center align of items
  final bool centerItem;

  /// vertical axis direction
  final bool isVertical;

  /// on tap function
  final Function onTap;

  /// list style
  final bool listStyle;

  MarkaaSelectOption({
    required this.items,
    this.value,
    this.values,
    required this.itemWidth,
    required this.itemHeight,
    this.itemSpace = 10,
    this.titleSize = 12,
    this.radius = 0,
    required this.selectedColor,
    required this.unSelectedColor,
    required this.selectedTitleColor,
    required this.unSelectedTitleColor,
    required this.selectedBorderColor,
    required this.unSelectedBorderColor,
    this.centerItem = true,
    this.isVertical = false,
    required this.onTap,
    this.listStyle = false,
  });

  @override
  _MarkaaSelectOptionState createState() => _MarkaaSelectOptionState();
}

class _MarkaaSelectOptionState extends State<MarkaaSelectOption> {
  @override
  Widget build(BuildContext context) {
    return !widget.listStyle
        ? Wrap(
            direction: !widget.isVertical ? Axis.horizontal : Axis.vertical,
            alignment: WrapAlignment.start,
            spacing: widget.itemSpace,
            children: List.generate(
              widget.items.length,
              (index) => Container(
                width: widget.itemWidth,
                child: MaterialButton(
                  height: widget.itemHeight,
                  onPressed: () => widget.onTap(widget.items[index].toString()),
                  color: widget.value == widget.items[index].toString() ||
                          (widget.values != null &&
                              widget.values!
                                  .contains(widget.items[index].toString()))
                      ? widget.selectedColor
                      : widget.unSelectedColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                    side: BorderSide(
                      color: widget.value == widget.items[index].toString() ||
                              (widget.values != null &&
                                  widget.values!
                                      .contains(widget.items[index].toString()))
                          ? widget.selectedBorderColor
                          : widget.unSelectedBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.items[index].toString(),
                      style: TextStyle(
                        color: widget.value == widget.items[index].toString() ||
                                (widget.values != null &&
                                    widget.values!.contains(
                                        widget.items[index].toString()))
                            ? widget.selectedTitleColor
                            : widget.unSelectedTitleColor,
                        fontSize: widget.titleSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : ListView(
            scrollDirection:
                widget.isVertical ? Axis.vertical : Axis.horizontal,
            children: List.generate(
              widget.items.length,
              (index) => Container(
                width: widget.itemWidth,
                margin: EdgeInsets.symmetric(horizontal: widget.itemSpace),
                child: MaterialButton(
                  height: widget.itemHeight,
                  onPressed: () => widget.onTap(widget.items[index].toString()),
                  color: widget.value == widget.items[index].toString() ||
                          (widget.values != null &&
                              widget.values!
                                  .contains(widget.items[index].toString()))
                      ? widget.selectedColor
                      : widget.unSelectedColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                    side: BorderSide(
                      color: widget.value == widget.items[index].toString() ||
                              (widget.values != null &&
                                  widget.values!
                                      .contains(widget.items[index].toString()))
                          ? widget.selectedBorderColor
                          : widget.unSelectedBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.items[index].toString(),
                      style: TextStyle(
                        color: widget.value == widget.items[index].toString() ||
                                (widget.values != null &&
                                    widget.values!.contains(
                                        widget.items[index].toString()))
                            ? widget.selectedTitleColor
                            : widget.unSelectedTitleColor,
                        fontSize: widget.titleSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
