import 'package:flutter/material.dart';

class FilterCustomOption extends StatefulWidget {
  /// items of radio buttons
  final List<dynamic> items;

  /// value of selected item
  final dynamic value;

  /// values of selected item multiple
  final List<dynamic>? values;

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

  FilterCustomOption({
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
  _FilterCustomOptionState createState() => _FilterCustomOptionState();
}

class _FilterCustomOptionState extends State<FilterCustomOption> {
  @override
  Widget build(BuildContext context) {
    return !widget.listStyle ? _buildNonListStyle() : _buildListStyle();
  }

  Widget _buildNonListStyle() {
    return Wrap(
      direction: !widget.isVertical ? Axis.horizontal : Axis.vertical,
      alignment: WrapAlignment.start,
      spacing: widget.itemSpace,
      children: List.generate(
        widget.items.length,
        (index) => _buildItem(index),
      ),
    );
  }

  Widget _buildListStyle() {
    return ListView(
      scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
      children: List.generate(
        widget.items.length,
        (index) => _buildItem(index),
      ),
    );
  }

  Widget _buildItem(int index) {
    bool isSingleSelected = widget.value == widget.items[index]['value'];
    bool isMultiSelected =
        widget.values!.indexOf(widget.items[index]['value']) >= 0;
    bool isSelected = isSingleSelected || isMultiSelected;
    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      child: Stack(
        children: [
          MaterialButton(
            height: widget.itemHeight,
            onPressed: () => widget.onTap(widget.items[index]),
            color: isSelected ? widget.selectedColor : widget.unSelectedColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              side: BorderSide(
                color: isSelected
                    ? widget.selectedBorderColor
                    : widget.unSelectedBorderColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                widget.items[index]['display'],
                style: TextStyle(
                  color: isSelected
                      ? widget.selectedTitleColor
                      : widget.unSelectedTitleColor,
                  fontSize: widget.titleSize,
                ),
              ),
            ),
          ),
          if (isSelected) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.check,
                  color: widget.selectedTitleColor,
                  size: widget.titleSize * 4 / 3,
                ),
              ),
            )
          ] else ...[
            SizedBox.shrink()
          ],
        ],
      ),
    );
  }
}
