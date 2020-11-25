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

  ConnectionState _previousActionState;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _action,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _previousActionState = snapshot.connectionState;
          return widget.progressView ?? _buildAction(ProgressUic(looseConstraints: true,));
        }
        else {
          if (_previousActionState == ConnectionState.waiting) {
            widget.onActionCompleted?.call();
          }
          _previousActionState = snapshot.connectionState;
          return _buildAction(widget.child);
        }
      },
    );
  }

  Widget _buildAction(Widget child) {
    return TextButton(
      onPressed: () {
        widget.onActionStarted?.call();
        setState(() {
          _action = widget.action();
        });
      },
      style: widget.style,
      child: child,
    );
  }
}