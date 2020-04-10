import 'package:flutter/material.dart';

class CheckboxUic extends StatefulWidget {
  CheckboxUic({
    Key key,
    this.initialValue = false,
    this.titleChecked = '',
    this.titleUnchecked = '',
    this.titleTextStyle,
    this.descriptionChecked = '',
    this.descriptionUnchecked = '',
    this.descriptionTextStyle,
    //
    this.tristate = false,
    @required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  final bool initialValue;

  final String titleChecked;

  final String titleUnchecked;

  final TextStyle titleTextStyle;

  final String descriptionChecked;

  final String descriptionUnchecked;

  final TextStyle descriptionTextStyle;

  final ValueChanged<bool> onChanged;

  //

  final Color activeColor;

  final Color checkColor;

  final bool tristate;

  final MaterialTapTargetSize materialTapTargetSize;

  final VisualDensity visualDensity;

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
              visualDensity: widget.visualDensity,
              focusColor: widget.focusColor,
              hoverColor: widget.hoverColor,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
            ),
            Text(_value ? widget.titleChecked : widget.titleUnchecked,
              style: widget.titleTextStyle ?? Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48.0),
          child: Text(_value ? widget.descriptionChecked : widget.descriptionUnchecked,
            textAlign: TextAlign.start,
            style: widget.descriptionTextStyle ?? Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }
}
