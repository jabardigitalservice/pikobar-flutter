import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Colors.dart';

enum CheckboxOrientation { HORIZONTAL, VERTICAL, WRAP }

class GroupedCheckBox extends StatefulWidget {
  /// A list of strings that will be displayed as labels for each check box.
  final List<String> itemLabelList;

  /// A list of strings that describe the value of each checkbox.
  /// Each item must be distinct.
  final List<String> itemValueList;

  /// A list of strings that determine the checkboxes that are checked automatically.
  /// Each element must match an item from the [itemValueList].
  final List<String> defaultSelectedList;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// value.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// GroupedCheckBox(
  ///   onChanged: (List<String> newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<List<String>> onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color activeColor;

  /// The color to use when this checkbox is unchecked.
  ///
  /// Defaults to Color(0xFFE0E0E0)
  final Color color;

  /// The orientation of the elements in itemList.
  ///
  /// Defaults to [CheckboxOrientation.WRAP].
  final CheckboxOrientation orientation;

  /// How much space to place between the end of the item.
  ///
  /// The [itemSpacing] can only work if [orientation] is
  /// [CheckboxOrientation.HORIZONTAL] or [CheckboxOrientation.VERTICAL]
  ///
  /// For example, if [CheckboxOrientation.HORIZONTAL] and [itemSpacing] is 10.0,
  /// the right side of the item will be spaced at least 10.0 pixels apart.
  ///
  /// Defaults to 0.0.
  final double itemSpacing;

  /// If non-null, require the item to have this width.
  ///
  /// If null, the item will pick a size based on children's size calculations.
  final double itemWidth;

  /// If non-null, require the item to have this height.
  ///
  /// Defaults to 40.0.
  final double itemHeight;

  /// The borderRadius specifies offsets in terms of visual corners
  ///
  /// If non-null, the corners of this box are rounded by this BorderRadiusGeometry value.
  ///
  /// If null, it is interpreted as [BorderRadius.zero].
  final BorderRadiusGeometry borderRadius;

  /// The style to use for the labels.
  final TextStyle textStyle;

  //.......................WRAP ORIENTATION.....................................

  /// The direction to use as the main axis.
  ///
  /// For example, if [wrapDirection] is [Axis.horizontal], the default, the
  /// children are placed adjacent to one another in a horizontal run until the
  /// available horizontal space is consumed, at which point a subsequent
  /// children are placed in a new run vertically adjacent to the previous run.
  final Axis wrapDirection;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapAlignment;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [wrapSpacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// If there is additional free space in a run (e.g., because the wrap has a
  /// minimum size that is not filled or because some runs are longer than
  /// others), the additional free space will be allocated according to the
  /// [wrapAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapSpacing;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [wrapRunSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [wrapRunAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapRunSpacing;

  GroupedCheckBox(
      {@required this.itemLabelList,
      @required this.itemValueList,
      @required this.orientation,
      this.defaultSelectedList,
      this.color,
      this.activeColor,
      this.textStyle,
      this.onChanged,
      this.itemSpacing = 0.0,
      this.itemWidth,
      this.itemHeight,
      this.borderRadius,
      this.wrapDirection = Axis.horizontal,
      this.wrapAlignment = WrapAlignment.start,
      this.wrapSpacing = 0.0,
      this.wrapRunSpacing = 0.0})
      : assert(itemLabelList.length == itemValueList.length);

  @override
  _GroupedCheckBoxState createState() => _GroupedCheckBoxState();
}

class _GroupedCheckBoxState extends State<GroupedCheckBox> {
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();

    if (widget.defaultSelectedList != null)
      selectedItems.addAll(widget.defaultSelectedList);
  }

  @override
  Widget build(BuildContext context) {
    return generateItems();
  }

  Widget generateItems() {
    List<Widget> content = [];
    List<Widget> widgetList = List<Widget>();

    for (int index = 0; index < widget.itemLabelList.length; index++) {
      widgetList.add(item(index));
    }

    if (widget.orientation == CheckboxOrientation.VERTICAL) {
      for (final item in widgetList) {
        content.add(Column(
            children: <Widget>[item, SizedBox(height: widget.itemSpacing)]));
      }

      return SingleChildScrollView(
          scrollDirection: Axis.vertical, child: Column(children: content));
    } else if (widget.orientation == CheckboxOrientation.HORIZONTAL) {
      for (final item in widgetList) {
        content.add(
            Row(children: <Widget>[item, SizedBox(width: widget.itemSpacing)]));
      }

      return SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: content));
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: widgetList,
            spacing: widget.wrapSpacing,
            runSpacing: widget.wrapRunSpacing,
            direction: widget.wrapDirection,
            alignment: widget.wrapAlignment,
          ),
        ),
      );
    }
  }

  Widget item(int index) {
    return Container(
      width: widget.itemWidth != null
          ? widget.itemWidth
          : widget.orientation == CheckboxOrientation.HORIZONTAL
              ? MediaQuery.of(context).size.width / 2.5
              : null,
      height: widget.itemHeight ?? 40.0,
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: selectedItems.contains(widget.itemValueList[index])
                ? widget.activeColor
                : widget.color,
          )),
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: () {
          if (!selectedItems.contains(widget.itemValueList[11]) &&
              selectedItems.isNotEmpty) {
            if (index == 11) {
            } else {
              if (selectedItems.contains(widget.itemValueList[index])) {
                selectedItems.remove(widget.itemValueList[index]);
              } else {
                selectedItems.add(widget.itemValueList[index]);
              }
            }
          } else {
            if (selectedItems.contains(widget.itemValueList[11])) {
              selectedItems.remove(widget.itemValueList[index]);
            } else {
              if (selectedItems.contains(widget.itemValueList[index])) {
                selectedItems.remove(widget.itemValueList[index]);
              } else {
                selectedItems.add(widget.itemValueList[index]);
              }
            }
          }

          setState(() {});
          widget.onChanged(selectedItems);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 16,
                height: 16,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                        color:
                            selectedItems.contains(widget.itemValueList[index])
                                ? widget.activeColor
                                : widget.color)),
                child: selectedItems.contains(widget.itemValueList[index])
                    ? Icon(FontAwesomeIcons.check,
                        size: 10,
                        color:
                            selectedItems.contains(widget.itemValueList[index])
                                ? widget.activeColor
                                : widget.color)
                    : null,
              ),
              Expanded(
                child: Text(widget.itemLabelList[index],
                    style: !selectedItems.contains(widget.itemValueList[11]) &&
                            selectedItems.isNotEmpty
                        ? index == 11
                            ? TextStyle(
                                fontFamily: FontsFamily.lato,
                                color: ColorBase.menuBorderColor,
                                fontSize: 12)
                            : widget.textStyle
                        : selectedItems.contains(widget.itemValueList[11])
                            ? index == 11
                                ? widget.textStyle
                                : TextStyle(
                                    fontFamily: FontsFamily.lato,
                                    color: ColorBase.menuBorderColor,
                                    fontSize: 12)
                            : widget.textStyle ??
                                TextStyle(fontFamily: FontsFamily.lato)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
