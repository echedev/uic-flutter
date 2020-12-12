import 'package:flutter/material.dart';
import 'package:uic/progress_uic.dart';

class ActionButton extends StatefulWidget {
  ActionButton({
    Key key,
    @required this.action,
    this.buttonType = ActionButtonType.text,
    @required this.child,
    this.onActionCompleted,
    this.onActionError,
    this.onActionStarted,
    this.progressView,
    this.style,
  }) : super(key: key);

  final Future<void> Function() action;

  final ActionButtonType buttonType;

  final Widget child;

  final VoidCallback onActionCompleted;

  final void Function(Object error) onActionError;

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
        print(_buttonSize.toString());
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
          return _buildAction(
              SizedBox(
                width: _buttonSize.width - (widget.progressView == null ? 0 : 32.0),
                height: _buttonSize.height - (widget.progressView == null ? 0 : 16.0),
                child: widget.progressView ?? ProgressUic(
                    size: _buttonSize.height,
                    looseConstraints: true,
                    color: widget.style?.foregroundColor?.resolve({MaterialState.focused}),
                ),
              ),
          );
        }
        else {
          if (_actionInProgress) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onActionError?.call(snapshot.error);
              });
            }
            else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onActionCompleted?.call();
              });
            }
            _actionInProgress = false;
          }
          return _buildAction(SizedBox(
            key: widget.progressView == null ? _buttonKey : null,
            child: widget.child,
          ));
        }
      },
    );
  }

  Widget _buildAction(Widget child) {
    switch (widget.buttonType) {
      case ActionButtonType.text:
        return TextButton(
          key: widget.progressView == null ? null : _buttonKey,
          onPressed: _onPressed,
          style: widget.style,
          child: child,
        );
      case ActionButtonType.elevated:
        return ElevatedButton(
          key: widget.progressView == null ? null : _buttonKey,
          onPressed: _onPressed,
          style: widget.style,
          child: child,
        );
      case ActionButtonType.outlined:
        return OutlinedButton(
          key: widget.progressView == null ? null : _buttonKey,
          onPressed: _onPressed,
          style: widget.style,
          child: child,
        );
      default:
        return Container();
    }
  }

  VoidCallback _onPressed() {
    if (!_actionInProgress) {
      widget.onActionStarted?.call();
      setState(() {
        _action = widget.action();
      });
    }
  }
}

enum ActionButtonType { text, elevated, outlined }