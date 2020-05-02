import 'package:flutter/material.dart';

/// A text widget, that let user inline edit the text it contains.
///
/// In view mode **InlineTextField** commonly looks like a [Text] widget.
/// Initial text to display is defined in [text] parameter.
/// Text appearance in view mode is defined by [style] parameter.
///
/// Instead of normal [Text] view, you can pass your custom widget in [child]
/// parameter, which will be shown in the view mode.
///
/// By double tap, user switch on the editing mode, that is turning the widget
/// to a [TextField].
/// Once text input submitted, the [onEditingComplete] callback is called, and
/// **InlineTextField** back to display updated text.
/// User can cancel editing by tap on build-in close icon button.
///
/// In editing mode you can customize input field using [styleEditing] and
/// [decoration]. By default, the collapsed input decoration is used.
///
/// Note: [InlineTextField] must be used inside a [Row] or other horizontal flex
/// widget, because it is expanded in its editing mode.
///
/// See also:
/// * [Text]
/// * [TextField]
/// * [TextStyle]
/// * [InputDecoration]
///
class InlineTextField extends StatefulWidget {
  InlineTextField({
    Key key,
    this.child,
    this.decoration,
    @required this.onEditingComplete,
    this.style,
    this.styleEditing,
    this.text,
  }) : assert(!(style != null && text == null),
        'Declaring style whithout text is not supported.'),
      assert(!(child != null && text != null),
        'Declaring both child and text is not supported.'),
      super(key: key);

  /// A widget to display in view mode
  final Widget child;

  /// The decoration to show around the text field.
  ///
  /// Defaults to [TextInputType.collapsed]
  final InputDecoration decoration;

  /// Called when the user indicates that they are done editing the text in the field.
  final void Function(String value) onEditingComplete;

  /// The text style in view mode
  ///
  /// If not specified, the theme's text style is used
  final TextStyle style;

  /// The text style of [TextField] in the editing mode
  ///
  /// If not specified, the theme's text style is used
  final TextStyle styleEditing;

  /// Initial text value
  final String text;

  @override
  _InlineTextFieldState createState() => _InlineTextFieldState();

}

class _InlineTextFieldState extends State<InlineTextField> {

  bool isEditing = false;
  
  TextEditingController _controller;

  String _oldText;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Expanded(
        child: TextField(
          controller: _controller,
          style: widget.styleEditing,
          decoration: widget.decoration?.copyWith(
            suffixIcon: _closeButton(),
          ) ?? InputDecoration.collapsed(
            hintText: "",
          ).copyWith(
              isDense: true,
              suffixIcon: _closeButton(),
          ),
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: (String newValue) {
            print("onSubmitted()");
            setState(() {
              isEditing = false;
            });
            widget.onEditingComplete(newValue);
          },
        ),
      );
    }
    else {
      return GestureDetector(
        onDoubleTap: () {
          setState(() {
            _oldText = _controller.value.text;
            isEditing = true;
          });
        },
        child: widget.child ??
            Text(_controller.value.text,
              style: widget.style,
            ),
      );
    }
  }

  Widget _closeButton() {
    return InkWell(
      child: Icon(Icons.close, size: 24.0),
      onTap: () {
        setState(() {
          _controller.text = _oldText;
          isEditing = false;
        });
      },
    );
  }
}