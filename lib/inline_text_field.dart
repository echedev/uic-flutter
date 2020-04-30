import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final Widget child;

  final InputDecoration decoration;

  final void Function(String value) onEditingComplete;

  final TextStyle style;

  final TextStyle styleEditing;

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
    return isEditing ?
      Expanded(
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
            suffixIconConstraints: BoxConstraints(
              minHeight: 24.0,
              minWidth: 24.0,
            )
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
      ) :
      GestureDetector(
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