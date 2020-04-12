library login_uic;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_uic.dart';

class LoginUic extends StatelessWidget {
  LoginUic({
    Key key,
    this.controller,
    this.usernameLabel = 'Email',
    this.usernameHint = 'Enter a username',
    this.usernameValidator,
    this.passwordLabel = 'Password',
    this.passwordHint = 'Enter a password',
    this.passwordValidator,
    this.signInText = 'Sign In',
    signInProgressView,
    this.theme,
    this.inputDecoration,
    this.errorTextStyle,
  }) : this.signInProgressView = signInProgressView ?? const ProgressUic(),
        super(key: key);

  final LoginUicController controller;

  final String usernameLabel;

  final String usernameHint;

  final String Function(String) usernameValidator;

  final String passwordLabel;

  final String passwordHint;

  final String Function(String) passwordValidator;

  final String signInText;

  final Widget signInProgressView;

  final ThemeData theme;

  final InputDecoration inputDecoration;

  final TextStyle errorTextStyle;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData eventualTheme = theme ?? Theme.of(context);
    TextStyle eventualErrorTextStyle = errorTextStyle ??
        eventualTheme.textTheme.body1.copyWith(color: Colors.redAccent);
    InputDecoration usernameDecoration = inputDecoration?.copyWith(
      labelText: usernameLabel,
      hintText: usernameHint,
    ) ?? InputDecoration(
      labelText: usernameLabel,
      hintText: usernameHint,
      filled: true,
    );
    InputDecoration passwordDecoration = inputDecoration?.copyWith(
      labelText: passwordLabel,
      hintText: passwordHint,
    ) ?? InputDecoration(
      labelText: passwordLabel,
      hintText: passwordHint,
      filled: true,
    );
    VoidCallback onSignInAction = () {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        controller.signIn();
      }
    };
    return ChangeNotifierProvider.value(
      value: controller.state,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Theme(
          data: eventualTheme,
          child: Form(
            key: _formKey,
            child: Consumer<ValueNotifier<LoginUicState>>(
              builder: (context, state, child) {
                if (state.value == LoginUicState.signInSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.state.value = LoginUicState.signIn;
                    controller.onSignedIn(context);
                  });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (state.value == LoginUicState.signInError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(controller.error,
                          style: eventualErrorTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: controller.usernameController,
                        decoration: usernameDecoration,
                        validator: usernameValidator,
                        onSaved: (newValue) => controller.username = newValue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: controller.passwordController,
                        decoration: passwordDecoration,
                        validator: passwordValidator,
                        onSaved: (newValue) => controller.password = newValue,
                        obscureText: true,
                      ),
                    ),
                    RaisedButton(
                      child: Container(
                        width: eventualTheme.buttonTheme.minWidth,
                        child: (state.value == LoginUicState.signInProgress)
                            ? signInProgressView
                            : Text(signInText, textAlign: TextAlign.center,),
                      ),
                      onPressed: (state.value == LoginUicState.signInProgress)
                          ? null : onSignInAction,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginUicController {
  LoginUicController({
    LoginUicState initialState = LoginUicState.signIn,
    @required this.onSignIn,
    void Function(BuildContext) onSignedIn,
  }) :  usernameController = TextEditingController(),
        passwordController = TextEditingController(),
        this.onSignedIn = onSignedIn ?? ((_) {}),
        _state = ValueNotifier(initialState);

  final ValueNotifier<LoginUicState> _state;
  ValueNotifier<LoginUicState> get state => _state;

  /// Callback to perform sign in
  Future<void> Function(String username, String password) onSignIn;

  /// Callback that is called on successfully signed in
  void Function(BuildContext context) onSignedIn;

  TextEditingController usernameController;

  String get username => usernameController.text;
  set username(String value) => usernameController.text = value.trim();

  TextEditingController passwordController;

  String get password => passwordController.text;
  set password(String value) => passwordController.text = value;

  String _error;
  String get error => _error;

  Future<void> signIn() async {
    state.value = LoginUicState.signInProgress;
    try {
      await onSignIn(username, password);
      state.value = LoginUicState.signInSuccess;
    } on String catch (error) {
      _error = error;
      state.value = LoginUicState.signInError;
    } catch (error) {
      _error = 'Sign in failed';
      state.value = LoginUicState.signInError;
    }
  }
}

enum LoginUicState {
  signIn, signInProgress, signInSuccess, signInError,
}