import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/_widgets.dart';

// Login

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin, WidgetsBindingObserver {
  final FocusNode _loginFN = FocusNode();
  final FocusNode _passFN = FocusNode();

  String _login = '';
  String _pass = '';
  double _overlap = 0;

  GlobalKey<_TextFieldState> loginKey = GlobalKey(), passKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _loginFN.addListener(() => setState(() {}));
    _passFN.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _loginFN.dispose();
    _passFN.dispose();
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  void _submit() {
    if (_validateLogin('') != null) loginKey.currentState!.shake();
    if (_validatePass('') != null) passKey.currentState!.shake();
  }

  @override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
    final keyboardTopPixels = window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap >= 0) setState(() => _overlap = overlap);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: _overlap),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              child: _TextField(
                key: loginKey,
                validate: _validateLogin,
                onChanged: (String s) => _login = s,
                focusNode: _loginFN,
                label: 'Username',
                onEditingComplete: () {
                  _loginFN.unfocus();
                  FocusScope.of(context).requestFocus(_passFN);
                },
              ),
            ),
            const SizedBox(height: 12.0),
            SlideIn(
              index: 2,
              child: _TextField(
                key: passKey,
                validate: _validatePass,
                onChanged: (String s) => _pass = s,
                focusNode: _passFN,
                obscure: true,
                label: 'Password',
                onEditingComplete: () => _passFN.unfocus(),
              ),
            ),
            const SizedBox(height: 16.0),
            SlideIn(
                index: 3,
                child: GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10)
                        ]),
                    child: Center(
                        child: Text('Login',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))),
                  ),
                )),
            const SizedBox(height: 14.0),
            SlideIn(
                index: 4,
                child: GestureDetector(
                    onTap: () {},
                    child: Text('Forgot Password',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff3e74ed))))),
            const SizedBox(height: 35.0),
            SlideIn(
                index: 5,
                child: Row(children: [
                  _SocialButton('assets/img/fb.svg'),
                  Container(width: 25),
                  _SocialButton('assets/img/google.svg')
                ])),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
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

  String? _validatePass(String? password) => !(_pass.length < 6) ? null : 'fsdfasd';
}

// Helpers

class _SocialButton extends StatelessWidget {
  final String asset;
  const _SocialButton(this.asset);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SvgPicture.asset(asset, width: 25, fit: BoxFit.scaleDown),
    );
  }
}

class _TextField extends StatefulWidget {
  const _TextField({
    Key? key,
    required this.validate,
    required this.onChanged,
    required this.onEditingComplete,
    required this.focusNode,
    required this.label,
    this.obscure = false,
  }) : super(key: key);

  final String? Function(String? value) validate;
  final Function onChanged, onEditingComplete;
  final FocusNode focusNode;
  final bool obscure;
  final String label;

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> with TickerProviderStateMixin {
  Animation? _shakeAnimation, _labelAnimation;
  AnimationController? _shakeController, _labelController;
  String text = "";
  bool lastFocus = false;

  @override
  void initState() {
    _shakeController = AnimationController(vsync: this, duration: Duration(milliseconds: 100))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _shakeController?.forward(from: 0);
      });
    _shakeAnimation = Tween<Offset>(begin: Offset(-2, 20), end: Offset(2, 20))
        .animate(CurvedAnimation(parent: _shakeController!, curve: Curves.elasticInOut));

    _labelController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _labelAnimation = CurvedAnimation(curve: Curves.easeInOutCubic, parent: _labelController!);

    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus && lastFocus && text.isEmpty) _labelController?.reverse();
      if (widget.focusNode.hasFocus && !lastFocus) _labelController?.forward();

      lastFocus = widget.focusNode.hasFocus;
    });

    super.initState();
  }

  Future shake() async {
    _shakeController?.forward();
    await Future<dynamic>.delayed(Duration(milliseconds: 500));
    _shakeController?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _shakeAnimation!,
            builder: (c, _) => Transform.translate(
              offset: _shakeAnimation!.value,
              child: Container(
                height: 40,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2), offset: Offset(7, 7), blurRadius: 15, spreadRadius: -6)
                ]),
                child: TextField(
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: (text.isEmpty || widget.validate('') != null)
                              ? BorderSide.none
                              : BorderSide(color: Color(0xffff0000), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: (text.isEmpty || widget.validate('') != null)
                              ? BorderSide.none
                              : BorderSide(color: Color(0xffff0000), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: (text.isEmpty || widget.validate('') != null)
                              ? BorderSide.none
                              : BorderSide(color: Color(0xffff0000), width: 1)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                      suffixIcon: widget.validate('') != null
                          ? SvgPicture.asset('assets/img/tick.svg', width: 8.5, fit: BoxFit.scaleDown)
                          : null),
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 12, color: Color(0xff1a1a1a)),
                  obscureText: widget.obscure,
                  onChanged: (s) {
                    text = s;
                    widget.onChanged(s);
                  },
                  onEditingComplete: () => setState(() => widget.onEditingComplete()),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _labelAnimation!,
            builder: (c, child) => Transform.translate(
              offset: Offset(lerpDouble(15, 0, _labelAnimation!.value)!, lerpDouble(31.5, 0, _labelAnimation!.value)!),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: lerpDouble(12, 10, _labelAnimation!.value),
                  fontWeight: _labelAnimation!.value < 0.5 ? FontWeight.w400 : FontWeight.w500,
                  color: _labelAnimation!.value < 0.5 ? Color(0xff1a1a1a) : Color(0xff666666),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shakeController?.dispose();
    _labelController?.dispose();

    super.dispose();
  }
}
