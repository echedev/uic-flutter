import 'package:flutter/material.dart';

class InlineTextField extends StatefulWidget {
  InlineTextField({
    Key key,
    @required this.onEditingComplete,
    this.style,
    @required this.value,
  }) : super(key: key);

  final void Function(String value) onEditingComplete;

  final TextStyle style;
  
  final String value;

  @override
  _InlineTextFieldState createState() => _InlineTextFieldState();

}

class _InlineTextFieldState extends State<InlineTextField> {

  bool isEditing = false;
  
  TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
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
            isEditing = true;
          });
        },
        child: Text(_controller.value.text)
      );
  }
}