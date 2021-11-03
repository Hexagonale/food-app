import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodapp/my_icons.dart';
import 'package:foodapp/widgets/_widgets.dart';

import '../widgets/_widgets.dart';

// Login

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocusNode.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 61.0),
              const SlideIn(
                index: 0,
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1a1a1a),
                  ),
                ),
              ),
              const SizedBox(height: 43.0),
              SlideIn(
                index: 1,
                child: MyTextFormField(
                  controller: _loginController,
                  validator: _validateLogin,
                  focusNode: _loginFocusNode,
                  label: 'Username',
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _loginFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passFocusNode);
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              SlideIn(
                index: 2,
                child: MyTextFormField(
                  controller: _passwordController,
                  validator: _validatePass,
                  focusNode: _passFocusNode,
                  obscure: true,
                  label: 'Password',
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _passFocusNode.unfocus,
                ),
              ),
              const SizedBox(height: 16.0),
              SlideIn(
                index: 3,
                child: MyButton(
                  text: 'Login',
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 14.0),
              SlideIn(
                index: 4,
                child: MyTextButton(
                  text: 'Forgot Password',
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 35.0),
              SlideIn(
                index: 5,
                child: _buildSocialButtons(),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: <Widget>[
        MyIconButton(
          icon: MyIcons.facebook,
          onPressed: () {},
        ),
        const SizedBox(width: 25.0),
        MyIconButton(
          icon: MyIcons.google,
          onPressed: () {},
        )
      ],
    );
  }

  String? _validateLogin(String? login) {
    if (login == null) {
      return 'Login cannot be empty.';
    }

    if (login.trim().isEmpty) {
      return 'Login cannot be empty.';
    }

    if (login.length < 6) {
      return 'Login has to have at least 6 characters.';
    }

    return null;
  }

  String? _validatePass(String? password) {
    if (password == null) {
      return 'Password cannot be empty.';
    }

    if (password.trim().isEmpty) {
      return 'Password cannot be empty.';
    }

    if (password.length < 6) {
      return 'Password has to have at least 6 characters.';
    }

    return null;
  }

  void _submit() {
    if (formKey.currentState?.validate() != true) {
      // There are errors in the form.
      return;
    }

    // TODO: Redirect.
  }
}
