import 'package:flutter/material.dart';
import 'package:uic/progress_uic.dart';

/// A wrapper of Material buttons, that manages a state of an [action] which is
/// performed on the button click, and updates the button content to display
/// the progress state of the action.
///
/// The [buttonType] property defines the underlying Material button widget -
/// [TextButton], [ElevatedButton] or [OutlineButton].
/// The [ActionButton] supports all attributes of those button widgets.
///
/// A function provided in the [action] attribute, is called when user click the
/// button. This function must return Future.
/// During performing the action, the [progressView] is displayed as a button [child].
/// When it is not specified, the [ProgressUic] widget is shown.
///
/// [ActionButton] provides callbacks for action states:
/// - [onActionStarted] is called immediately after clicking the button, before
/// the action is started,
/// - [onActionCompleted] is called when the action is successfully completed,
/// - [onActionError] is called if the action finished with error.
///
/// See also:
/// * [ActionButtonType]
/// * [ProgressUic]
/// * [TextButton]
/// * [ElevatedButton]
/// * [OutlineButton]
///
class ActionButton extends StatefulWidget {
  ActionButton({
    Key key,
    @required this.action,
    this.autofocus = false,
    this.buttonType = ActionButtonType.text,
    @required this.child,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.onActionCompleted,
    this.onActionError,
    this.onActionStarted,
    this.progressView,
    this.style,
  }) : super(key: key);

  /// An action, that is performed on button pressed.
  ///
  /// Until the future, returned by this function, is completed, the
  /// button's child is changed to [progressView].
  final Future<void> Function() action;

  final bool autofocus;

  /// Defines the underlying Material button widget.
  ///
  /// Defaults to [ActionButtonType.text].
  final ActionButtonType buttonType;

  final Widget child;

  final Clip clipBehavior;

  final FocusNode focusNode;

  /// A callback that is called when the action is successfully completed.
  final VoidCallback onActionCompleted;

  /// A callback that is called when the action is finished with error.
  final void Function(Object error) onActionError;

  /// A callback that is called immediately after the button is pressed,
  /// before starting the action.
  final VoidCallback onActionStarted;

  /// A custom view, that is displayed as a button child when the action is
  /// in progress.
  ///
  /// When not specified, the [ProgressUic] is used as a progress view.
  final Widget progressView;

  final ButtonStyle style;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Future<void> _action;

  bool _actionInProgress = false;

  final GlobalKey _buttonKey = GlobalKey();

  Size _buttonSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_buttonSize == null) {
        final RenderBox renderBox =
            _buttonKey.currentContext.findRenderObject();
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
              width:
                  _buttonSize.width - (widget.progressView == null ? 0 : 32.0),
              height:
                  _buttonSize.height - (widget.progressView == null ? 0 : 16.0),
              child: widget.progressView ??
                  ProgressUic(
                    size: _buttonSize.height,
                    looseConstraints: true,
                    color: widget.style?.foregroundColor
                        ?.resolve({MaterialState.focused}),
                  ),
            ),
          );
        } else {
          if (_actionInProgress) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onActionError?.call(snapshot.error);
              });
            } else {
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
          clipBehavior: widget.clipBehavior,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          child: child,
        );
      case ActionButtonType.elevated:
        return ElevatedButton(
          key: widget.progressView == null ? null : _buttonKey,
          onPressed: _onPressed,
          style: widget.style,
          clipBehavior: widget.clipBehavior,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          child: child,
        );
      case ActionButtonType.outlined:
        return OutlinedButton(
          key: widget.progressView == null ? null : _buttonKey,
          onPressed: _onPressed,
          style: widget.style,
          clipBehavior: widget.clipBehavior,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          child: child,
        );
      default:
        return Container();
    }
  }

  void _onPressed() {
    if (!_actionInProgress) {
      widget.onActionStarted?.call();
      setState(() {
        _action = widget.action();
      });
    }
  }
}

enum ActionButtonType { text, elevated, outlined }
