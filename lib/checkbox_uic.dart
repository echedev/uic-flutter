library checkbox_uic;

import 'package:flutter/material.dart';

/// Enhanced checkbox widget, that maintain its state, has a title and can show
/// additional description in each state.
///
/// **CheckboxUic** is an original [Checkbox] widget, composed with a [title]
/// and optional [description] text.
/// For unchecked state it also allows to set individual [titleUnchecked] and
/// [descriptionUnchecked] values.
///
/// For description, instead of just a text, you can pass your custom views in
/// [descriptionView] and [descriptionViewUnchecked] parameters.
///
/// This widget, unlike the original [Checkbox], maintain its own state (checked
/// or unchecked). You can set the initial state with [initialValue] parameter.
///
/// All original [Checkbox] parameters are supported.
///
/// When the state is changed, the [onChanged] callback is called with updated
/// state. If the [onChanged] isn't, the **CheckboxUic** is disabled.
///
/// See also:
/// * [Checkbox]
///
class CheckboxUic extends StatefulWidget {
  CheckboxUic({
    Key key,
    this.initialValue = false,
    this.title = '',
    this.titleUnchecked,
    this.titleTextStyle,
    this.description,
    this.descriptionUnchecked,
    this.descriptionTextStyle,
    this.descriptionView,
    this.descriptionViewUnchecked,
    //
    this.tristate = false,
    this.onChanged,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  /// Initial state of the checkbox
  final bool initialValue;

  /// Title text to display near the checkbox
  final String title;

  /// Optional title text for unchecked state
  final String titleUnchecked;

  /// Style of the title text
  final TextStyle titleTextStyle;

  /// Optional description text
  ///
  /// If defined, it is displayed below the title
  final String description;

  /// Optional description text for unchecked state
  ///
  /// If defined, it is displayed below the title
  final String descriptionUnchecked;

  /// Style of description text
  final TextStyle descriptionTextStyle;

  /// Widget to display in the description area
  final Widget descriptionView;

  /// Widget to display in the description area for unchecked state
  final Widget descriptionViewUnchecked;

  /// A callback function that is called when the check box state is changed
  final ValueChanged<bool> onChanged;

  //

  final Color activeColor;

  final Color checkColor;

  final bool tristate;

  final MaterialTapTargetSize materialTapTargetSize;

  final Color focusColor;

  final Color hoverColor;

  final FocusNode focusNode;

  final bool autofocus;

  @override
  _CheckboxUicState createState() => _CheckboxUicState();
}

class _CheckboxUicState extends State<CheckboxUic> {

  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle eventualTitleTextStyle = widget.titleTextStyle ??
        Theme.of(context).textTheme.subtitle2;
    if (widget.onChanged == null) {
      eventualTitleTextStyle = eventualTitleTextStyle.copyWith(
        color: Theme.of(context).disabledColor,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _value,
              onChanged: widget.onChanged == null ? null : (value) {
                widget.onChanged(value);
                setState(() {
                  _value = value;
                });
              },
              //
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
              tristate: widget.tristate,
              materialTapTargetSize: widget.materialTapTargetSize,
              focusColor: widget.focusColor,
              hoverColor: widget.hoverColor,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
            ),
            Text(_value ? widget.title : widget.titleUnchecked ?? widget.title,
              style: eventualTitleTextStyle,
            ),
          ],
        ),
        if (widget.description != null)
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Text(_value ? widget.description
                : widget.descriptionUnchecked ?? widget.description,
              textAlign: TextAlign.start,
              style: widget.descriptionTextStyle ?? Theme.of(context).textTheme.caption,
            ),
          ),
        if (widget.descriptionView != null)
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: _value ? widget.descriptionView
                : widget.descriptionViewUnchecked ?? widget.descriptionView,
          ),
      ],
    );
  }
}
