import 'package:flutter/material.dart';
import 'package:foodapp/my_icons.dart';
import 'package:foodapp/screens/welcome/widgets/_widgets.dart';
import 'package:foodapp/utils.dart';
import 'package:foodapp/widgets/_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
    required this.onSubmit,
    required this.onLogin,
  }) : super(key: key);

  final Function() onSubmit;
  final Function() onLogin;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 61.0),
              const SlideIn(
                index: 0,
                child: Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1a1a1a),
                  ),
                ),
              ),
              const SizedBox(height: 43.0),
              SlideIn(
                index: 1,
                child: MyTextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: _validateEmail,
                  label: 'Email',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_loginFocusNode);
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              SlideIn(
                index: 2,
                child: MyTextFormField(
                  controller: _loginController,
                  focusNode: _loginFocusNode,
                  validator: _validateLogin,
                  label: 'Username',
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _loginFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              SlideIn(
                index: 3,
                child: MyTextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  validator: _validatePassword,
                  label: 'Password',
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  onEditingComplete: _passwordFocusNode.unfocus,
                ),
              ),
              const SizedBox(height: 16.0),
              SlideIn(
                index: 4,
                child: MyButton(
                  onPressed: _signUp,
                  text: 'Sign Up',
                ),
              ),
              const SizedBox(height: 14.0),
              SlideIn(
                index: 5,
                child: MyTextButton(
                  onPressed: widget.onLogin,
                  text: 'Have an account',
                ),
              ),
              const SizedBox(height: 35.0),
              SlideIn(
                index: 6,
                child: Row(
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
                ),
              ),
              const SizedBox(height: 15.0)
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? email) {
    if (email == null) {
      return 'Email cannot be empty.';
    }

    if (email.isEmpty) {
      return 'Email cannot be empty.';
    }

    if (!isEmail(email)) {
      return 'Email is incorrect.';
    }

    return null;
  }

  String? _validateLogin(String? login) {
    if (login == null) {
      return 'Login cannot be empty.';
    }

    if (login.isEmpty) {
      return 'Login cannot be empty.';
    }

    if (login.length < 6) {
      return 'Login has to have at least 6 characters.';
    }

    return null;
  }

  String? _validatePassword(String? password) {
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

  void _signUp() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    widget.onSubmit();
  }
}
