import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

enum RadioButtonOrientation { HORIZONTAL, VERTICAL, WRAP }

class GroupedRadioButton extends StatefulWidget {
  /// A list of strings that will be displayed as labels for each radio button.
  final List<String> itemLabelList;

  /// A list of strings that determine the radio button that are selected automatically.
  /// Each element must match an item from the [itemValueList].
  final int defaultSelectedIndex;

  /// Called when the value of the radio button should change.
  ///
  /// The radio button passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the radio button with the new
  /// value.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// GroupedRadioButton(
  ///   onChanged: (String label, int index) {
  ///     setState(() {
  ///       _throwShotAway = _itemLabelList[newItem];
  ///     });
  ///   },
  /// )
  /// ```
  final void Function(String label, int index) onChanged;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise; for example:
  ///
  /// ```dart
  /// GroupedRadioButton(
  ///   validator: (string) {
  ///     return _isEmpty ? 'Empty field' : null;
  ///   },
  /// )
  /// ```
  final String Function(String value) validator;

  /// The color to use when this radio button is selected.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color activeColor;

  /// The color to use when this radio button is unselected.
  ///
  /// Defaults to Color(0xFFE0E0E0)
  final Color color;

  /// The orientation of the elements in itemList.
  ///
  /// Defaults to [RadioButtonOrientation.WRAP].
  final RadioButtonOrientation orientation;

  /// How much space to place between the end of the item.
  ///
  /// The [itemSpacing] can only work if [orientation] is
  /// [RadioButtonOrientation.HORIZONTAL] or [RadioButtonOrientation.VERTICAL]
  ///
  /// For example, if [RadioButtonOrientation.HORIZONTAL] and [itemSpacing] is 10.0,
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

  GroupedRadioButton(
      {@required this.itemLabelList,
      @required this.orientation,
      this.defaultSelectedIndex,
      this.color,
      this.activeColor,
      this.textStyle,
      this.onChanged,
      this.validator,
      this.itemSpacing = 0.0,
      this.itemWidth,
      this.itemHeight,
      this.borderRadius,
      this.wrapDirection = Axis.horizontal,
      this.wrapAlignment = WrapAlignment.start,
      this.wrapSpacing = 0.0,
      this.wrapRunSpacing = 0.0})
      : assert(
            defaultSelectedIndex != null
                ? defaultSelectedIndex < itemLabelList.length
                : true,
            "The defaultSelected index value must be less than the number of items. (< ${itemLabelList.length})");

  @override
  _GroupedRadioButtonState createState() => _GroupedRadioButtonState();
}

class _GroupedRadioButtonState extends State<GroupedRadioButton> {
  int currentSelectedIndex;
  String currentSelectedLabel;

  @override
  void initState() {
    super.initState();

    if (widget.defaultSelectedIndex != null) {
      currentSelectedIndex = widget.defaultSelectedIndex;
      currentSelectedLabel = widget.itemLabelList[widget.defaultSelectedIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateItems();
  }

  Widget generateItems() {
    List<Widget> content = [];
    List<Widget> widgetList = List<Widget>();

    String validatorValue = widget.validator?.call(currentSelectedLabel);

    for (int index = 0; index < widget.itemLabelList.length; index++) {
      widgetList.add(item(index, validatorValue));
    }

    if (widget.orientation == RadioButtonOrientation.VERTICAL) {
      for (final item in widgetList) {
        content.add(Column(
            children: <Widget>[item, SizedBox(height: widget.itemSpacing)]));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: validatorValue != null
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0))
                  : null,
              padding: validatorValue != null ? EdgeInsets.all(10.0) : null,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content))),
          validatorValue != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: Dimens.contentPadding, top: Dimens.sizedBoxHeight),
                  child: Text(
                    validatorValue,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : Container()
        ],
      );
    } else if (widget.orientation == RadioButtonOrientation.HORIZONTAL) {
      for (final item in widgetList) {
        content.add(
            Row(children: <Widget>[item, SizedBox(width: widget.itemSpacing)]));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: validatorValue != null
                ? BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0))
                : null,
            padding: validatorValue != null ? EdgeInsets.all(10.0) : null,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: content)),
          ),
          validatorValue != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: Dimens.contentPadding, top: Dimens.sizedBoxHeight),
                  child: Text(
                    validatorValue,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : Container()
        ],
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: validatorValue != null
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0))
                  : null,
              padding: validatorValue != null ? EdgeInsets.all(10.0) : null,
              child: Wrap(
                children: widgetList,
                spacing: widget.wrapSpacing,
                runSpacing: widget.wrapRunSpacing,
                direction: widget.wrapDirection,
                alignment: widget.wrapAlignment,
              ),
            ),
            validatorValue != null
                ? Padding(
                    padding: EdgeInsets.only(
                        left: Dimens.contentPadding, top: Dimens.sizedBoxHeight),
                    child: Text(
                      validatorValue,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : Container()
          ],
        ),
      );
    }
  }

  Widget item(int index, String validatorValue) {
    return Container(
      width: widget.itemWidth != null
          ? widget.itemWidth - (validatorValue != null ? 11.0 : 0.0)
          : widget.orientation == RadioButtonOrientation.HORIZONTAL
              ? MediaQuery.of(context).size.width / 2.5
              : null,
      height: widget.itemHeight ?? 40.0,
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: () {
          setState(() {
            currentSelectedIndex = index;
            currentSelectedLabel = widget.itemLabelList[index];
            widget.onChanged(currentSelectedLabel, currentSelectedIndex);
          });
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 23,
              height: 23,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                      color: currentSelectedIndex == index
                          ? widget.activeColor
                          : widget.color)),
              child: currentSelectedIndex == index
                  ? Container(
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: currentSelectedIndex == index
                              ? widget.activeColor
                              : widget.color),
                    )
                  : null,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(widget.itemLabelList[index],
                  style: widget.textStyle ??
                      TextStyle(fontFamily: FontsFamily.lato)),
            ),
          ],
        ),
      ),
    );
  }
}
