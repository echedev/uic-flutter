import 'package:flutter/material.dart';

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

  final bool initialValue;

  final String title;

  final String titleUnchecked;

  final TextStyle titleTextStyle;

  final String description;

  final String descriptionUnchecked;

  final TextStyle descriptionTextStyle;

  final Widget descriptionView;

  final Widget descriptionViewUnchecked;

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
        Theme.of(context).textTheme.subtitle;
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
