import 'package:flutter/material.dart';
import 'package:foodapp/my_icons.dart';
import 'package:foodapp/utils.dart';
import 'package:foodapp/widgets/_widgets.dart';

import '../widgets/_widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpView> with AutomaticKeepAliveClientMixin<SignUpView> {
  final PageController _controller = PageController();

  bool _wantKeepAlive = true;

  @override
  bool get wantKeepAlive => _wantKeepAlive;

  @override
  void dispose() {
    _controller.dispose();

    _wantKeepAlive = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PageView(
      children: <Widget>[
        _SignUpAccountPage(
          onSubmit: _goToNextPage,
          onLogin: () {},
        ),
        _SignUpPhonePage(
          onSubmit: _goToNextPage,
        ),
        _SignUpPhoneVerificationPage()
      ],
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _goToNextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }
}

class _SignUpAccountPage extends StatefulWidget {
  const _SignUpAccountPage({
    Key? key,
    required this.onSubmit,
    required this.onLogin,
  }) : super(key: key);

  final Function() onSubmit;
  final Function() onLogin;

  @override
  _SignUpAccountPageState createState() => _SignUpAccountPageState();
}

class _SignUpAccountPageState extends State<_SignUpAccountPage> with TickerProviderStateMixin {
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

class _SignUpPhonePage extends StatefulWidget {
  const _SignUpPhonePage({
    required this.onSubmit,
  });

  final Function() onSubmit;

  @override
  _SignUpPhonePageState createState() => _SignUpPhonePageState();
}

class _SignUpPhonePageState extends State<_SignUpPhonePage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _numberController.dispose();
    _codeFocusNode.dispose();
    _numberFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 61.0),
            const Text(
              'Enter your mobile\nnumber',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: Color(0xff1a1a1a),
              ),
            ),
            const SizedBox(height: 27.0),
            MyTextFormField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              validator: _validateCode,
              label: 'Country Code',
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                _codeFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_numberFocusNode);
              },
            ),
            const SizedBox(height: 12.0),
            MyTextFormField(
              controller: _numberController,
              focusNode: _numberFocusNode,
              validator: _validateNumber,
              label: 'Mobile Number',
              textInputAction: TextInputAction.done,
              onEditingComplete: _numberFocusNode.unfocus,
            ),
            const SizedBox(height: 16.0),
            MyButton(
              text: 'Continue',
              onPressed: _submit,
            ),
            const SizedBox(height: 35.0),
            SocialButtonRow(
              onFacebookPressed: () {},
              onGooglePressed: () {},
            ),
            const SizedBox(height: 15.0)
          ],
        ),
      ),
    );
  }

  String? _validateNumber(String? number) {
    if (number == null) {
      return 'Number cannot be empty.';
    }

    if (number.isEmpty) {
      return 'Number cannot be empty.';
    }

    if (number.trim().length < 9) {
      return 'Number has t have 9 letters.';
    }

    return null;
  }

  String? _validateCode(String? code) {
    if (code == null) {
      return 'Country code cannot be empty.';
    }

    if (code.isEmpty) {
      return 'Country code cannot be empty.';
    }

    if (code.length < 2) {
      return 'Country must be at least 2 digits.';
    }

    return null;
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    widget.onSubmit();
  }
}

class _SignUpPhoneVerificationPage extends StatefulWidget {
  @override
  _SignUpPhoneVerificationPageState createState() => _SignUpPhoneVerificationPageState();
}

class _SignUpPhoneVerificationPageState extends State<_SignUpPhoneVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
