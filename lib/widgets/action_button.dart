import 'package:flutter/material.dart';
import 'package:uic/progress_uic.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    Key key,
    @required this.action,
    @required this.child,
    this.onActionCompleted,
    this.onActionStarted,
    this.progressView,
    this.style,
  }) : super(key: key);

  final Future<void> Function() action;

  final Widget child;

  final VoidCallback onActionCompleted;

  final VoidCallback onActionStarted;

  final Widget progressView;

  final ButtonStyle style;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {

  Future<void>  _action;

  bool _actionInProgress = false;

  final GlobalKey _buttonKey = GlobalKey();

  Size _buttonSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_buttonSize == null) {
        final RenderBox renderBox = _buttonKey.currentContext
            .findRenderObject();
        _buttonSize = renderBox.size;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _action,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _actionInProgress = true;
          return widget.progressView ?? _buildAction(
              SizedBox(
                width: _buttonSize.width - 16.0,
                child: ProgressUic(
                  size: _buttonSize.height - 32.0,
                  color: widget.style?.foregroundColor?.resolve({MaterialState.focused}),
                ),
              ),
          );
        }
        else {
          if (_actionInProgress) {
            if (snapshot.hasError) {
              // TODO: Add 'onError' callback
              print("Error");
            }
            else {
              widget.onActionCompleted?.call();
            }
            _actionInProgress = false;
          }
          return _buildAction(widget.child);
        }
      },
    );
  }

  Widget _buildAction(Widget child) {
    return TextButton(
      key: _buttonSize == null ? _buttonKey : null,
      onPressed: () {
        if (!_actionInProgress) {
          widget.onActionStarted?.call();
          setState(() {
            _action = widget.action();
          });
        }
      },
      style: widget.style,
      child: child,
    );
  }
}