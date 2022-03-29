library login_uic;

import 'package:flutter/material.dart';

import 'widgets.dart';

/// A Login form, that is composed of 'Username' and 'Password' text fields, and
/// a 'Sign In' button.
///
/// The basic usage of **LoginUic** widget requires only to specify [onSignIn]
/// callback, that performs the actual signing in process, and optional
/// [onSignInCompleted] callback, where you implement actions on successful
/// signing in, like navigation to another screen.
/// All other logic, like basic input validation, managing the form state while
/// signing in is performing and handling sign in errors are under the hood.
///
/// For more control, you can provide your custom [usernameValidator] and
/// [passwordValidator] functions.
///
/// The appearance of the Login form can be adjusted with [theme], [inputDecoration],
/// [errorTextStyle] and [signInProgressView] parameters.
///
/// The Login form is using default field names, error messages and other texts
/// in English. To provide your custom string values, use [strings] parameter.
///
/// See also:
/// * [LoginUicStrings]
///
class LoginUic extends StatefulWidget {
  /// Creates LoginUic widget.
  ///
  const LoginUic({
    Key? key,
    this.errorTextStyle,
    this.inputDecoration,
    required this.onSignIn,
    this.onSignInCompleted,
    this.passwordValidator,
    this.signInProgressView,
    this.strings = const LoginUicStrings(),
    this.theme,
    this.usernameValidator,
  }) : super(key: key);

  /// A callback that performs sign in action.
  ///
  /// The 'username' and 'password' from user input are provided to this function.
  final Future<void> Function(String username, String password) onSignIn;

  /// A callback that is called on successful signing in.
  ///
  /// The current [BuildContext]  is provided, which can be used to navigate to
  /// another screen.
  final void Function(BuildContext context)? onSignInCompleted;

  /// A function that validates user's password
  ///
  /// The default validator checks if the user entered non-empty value.
  /// If the 'Password' field is empty, the [LoginUicStrings.passwordErrorEmpty]
  /// message is displayed.
  final String Function(String?)? passwordValidator;

  /// A custom view to show on the 'Sign In' button, while the signing in is
  /// is performed.
  ///
  /// Defaults to [CircularProgressIndicator]
  final Widget? signInProgressView;

  /// A theme, which is used to display a Login form
  ///
  /// When it is omitted, the current theme is used.
  final ThemeData? theme;

  /// Decoration of the 'Username' and 'Password' text fields.
  ///
  /// Defaults to current theme.
  final InputDecoration? inputDecoration;

  /// A style of error messages in the 'Username' and 'Password' text fields.
  ///
  /// Defaults to current theme.
  final TextStyle? errorTextStyle;

  /// A set of strings that are used in the Login form.
  ///
  /// Includes default label and hint of 'Username' and 'Password' field, 'Sign In'
  /// button text, basic error messages.
  /// You can use [LoginUicStrings] object to provide your custom or localized strings.
  final LoginUicStrings strings;

  /// A function that validates username.
  ///
  /// The default validator checks if the user entered non-empty value.
  /// If the 'Username' field is empty, the [LoginUicStrings.usernameErrorEmpty]
  /// message is displayed.
  final String Function(String?)? usernameValidator;

  @override
  _LoginUicState createState() => _LoginUicState();
}

class _LoginUicState extends State<LoginUic> {
  final _formKey = GlobalKey<FormState>();

  String _error = '';

  final ValueNotifier<_InternalLoginUicState> _state =
      ValueNotifier(_InternalLoginUicState.ready);

  String get username => _usernameController.text;
  set username(String value) => _usernameController.text = value.trim();

  final TextEditingController _usernameController = TextEditingController();

  String get password => _passwordController.text;
  set password(String value) => _passwordController.text = value;

  final TextEditingController _passwordController = TextEditingController();

  TextStyle? eventualErrorTextStyle;

  InputDecoration? usernameDecoration;

  InputDecoration? passwordDecoration;

  @override
  Widget build(BuildContext context) {
    ThemeData eventualTheme = widget.theme ?? Theme.of(context);
    eventualErrorTextStyle = widget.errorTextStyle ??
        eventualTheme.textTheme.bodyText2?.copyWith(color: Colors.redAccent);
    usernameDecoration = widget.inputDecoration?.copyWith(
          labelText: widget.strings.usernameLabel,
          hintText: widget.strings.usernameHint,
        ) ??
        InputDecoration(
          labelText: widget.strings.usernameLabel,
          hintText: widget.strings.usernameHint,
          filled: true,
        );
    passwordDecoration = widget.inputDecoration?.copyWith(
          labelText: widget.strings.passwordLabel,
          hintText: widget.strings.passwordHint,
        ) ??
        InputDecoration(
          labelText: widget.strings.passwordLabel,
          hintText: widget.strings.passwordHint,
          filled: true,
        );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Theme(
        data: eventualTheme,
        child: ValueListenableBuilder<_InternalLoginUicState>(
          valueListenable: _state,
          builder: (context, state, child) {
            return Column(
              children: [
                _buildForm(state),
                ActionButton(
                  action: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState?.validate() ?? false) {
                      await widget.onSignIn(username, password);
                    } else {
                      await Future.error(_InternalLoginUicState.validationError);
                    }
                  },
                  progressView: widget.signInProgressView,
                  buttonType: ActionButtonType.elevated,
                  onActionStarted: () {
                    _state.value = _InternalLoginUicState.inProgress;
                  },
                  onActionCompleted: () {
                    _state.value = _InternalLoginUicState.success;
                  },
                  onActionError: (error) {
                    if (error == _InternalLoginUicState.validationError) {
                      _error = '';
                      _state.value = _InternalLoginUicState.validationError;
                    } else {
                      if (error is String) {
                        _error = error;
                      } else {
                        _error = widget.strings.signInError;
                      }
                      _state.value = _InternalLoginUicState.error;
                    }
                  },
                  child: Text(
                    widget.strings.signInButtonText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(_InternalLoginUicState state) {
    if (state == _InternalLoginUicState.success) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _state.value = _InternalLoginUicState.ready;
        widget.onSignInCompleted?.call(context);
      });
    } else if (state ==
        _InternalLoginUicState.validationError) {
      _formKey.currentState?.validate();
    }
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (state == _InternalLoginUicState.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _error,
                style: eventualErrorTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              controller: _usernameController,
              decoration: usernameDecoration,
              enabled: state !=
                  _InternalLoginUicState.inProgress,
              validator: widget.usernameValidator ??
                      (value) => (value?.isEmpty ?? true)
                      ? widget.strings.usernameErrorEmpty
                      : null,
              onSaved: (newValue) => username = (newValue ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              controller: _passwordController,
              decoration: passwordDecoration,
              enabled: state !=
                  _InternalLoginUicState.inProgress,
              validator: widget.passwordValidator ??
                      (value) => (value?.isEmpty ?? true)
                      ? widget.strings.passwordErrorEmpty
                      : null,
              onSaved: (newValue) => password = (newValue ?? ''),
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// A container for string values, which are used in the [LoginUic]
///
class LoginUicStrings {
  /// Creates an instance of LoginUicStrings.
  ///
  const LoginUicStrings({
    this.usernameErrorEmpty = 'Please enter a username.',
    this.usernameLabel = 'Email',
    this.usernameHint = 'Enter a username',
    this.passwordErrorEmpty = 'Please enter a password.',
    this.passwordLabel = 'Password',
    this.passwordHint = 'Enter a password',
    this.signInButtonText = 'Sign In',
    this.signInError = 'Sign In failed.',
  });

  /// An error message, that displayed when the 'Username' field is empty.
  final String usernameErrorEmpty;

  /// A label of 'Username' field.
  final String usernameLabel;

  /// Text to display in the 'Username' input field, when the value is not entered yet.
  final String usernameHint;

  /// An error message, that displayed when the 'Password' field is empty.
  final String passwordErrorEmpty;

  /// A label of 'Password' field.
  final String passwordLabel;

  /// Text to display in the 'Password' input field, when the value is not entered yet.
  final String passwordHint;

  /// A title of 'Sign In' button
  final String signInButtonText;

  /// An error message that is displayed when the signing in failed.
  final String signInError;
}

enum _InternalLoginUicState {
  error,
  inProgress,
  ready,
  success,
  validationError,
}
