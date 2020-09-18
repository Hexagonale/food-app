import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils.dart';

// TODO Verification process

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  TabController _controller;
  Animation _logoAnimation;
  AnimationController _logoController;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _logoController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _logoAnimation = CurvedAnimation(curve: Curves.elasticOut, parent: _logoController);

    WidgetsBinding.instance.addPostFrameCallback((_) => _logoController.forward(from: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            height: 266,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
              boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10) ]
            ),
            child: Column(children: [
              Container(height: 96),

              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) => Transform.scale(scale: _logoAnimation.value, child: child),
                child: Container(
                  width: 65,
                  height: 65,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10) ]
                  ),
                  child: SvgPicture.asset('assets/img/logo.svg', alignment: Alignment.center)
                ),
              ),

              Container(height: 50),

              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                child: TabBar(
                  controller: _controller,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 5,
                  tabs: [ _Tab('Login', 0, _controller), _Tab('Sign Up', 1, _controller) ]
                ),
              ))
            ])
          ),

          Expanded(child: TabBarView(controller: _controller,  children: [
            _Login(),
            _SignUp(_controller)
          ]))
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _logoController.dispose();
    super.dispose();
  }
}

// Login
bool _loginPlayed = false;
class _Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> with TickerProviderStateMixin, WidgetsBindingObserver {
  String _login = "", _pass = "";
  FocusNode _loginFN = FocusNode(), _passFN = FocusNode();
  double _overlap = 0;
  List<Animation> _animations;
  List<AnimationController> _controllers;
  GlobalKey<_TextFieldState> loginKey = GlobalKey(), passKey = GlobalKey();

  bool _validateLogin() => !(_login.length < 6);
  bool _validatePass() => !(_pass.length < 6);

  @override
  void initState() {
    _loginFN.addListener(() => setState(() {}));
    _passFN.addListener(() => setState(() {}));

    _controllers = List.generate(6, (i) => AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
    _animations = List.generate(6, (i) => CurvedAnimation(curve: Curves.easeOutExpo, parent: _controllers[i]));

    if(_loginPlayed) _controllers.forEach((c) => c.value = 1);

    WidgetsBinding.instance..addObserver(this)..addPostFrameCallback((_) => _startAnimations());
    super.initState();
  }

  void _startAnimations() async {
    if(_loginPlayed) return;

    for(int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward(from: 0);
      await Future.delayed(Duration(milliseconds: 200));
    }

    _loginPlayed = true;
  }

  void _submit() {
    if(!_validateLogin()) loginKey.currentState.shake();
    if(!_validatePass()) passKey.currentState.shake();

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
    return SingleChildScrollView(padding: EdgeInsets.only(bottom: _overlap), child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(height: 61),

        _SlideIn(animation: _animations[0], child: Text('Welcome back', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Color(0xff1a1a1a)))),

        Container(height: 43),

        _SlideIn(animation: _animations[1], child: _TextField(key: loginKey, validate: _validateLogin, onChanged: (s) => _login = s, focusNode: _loginFN, label: 'Username', onEditingComplete: () {
          _loginFN.unfocus();
          FocusScope.of(context).requestFocus(_passFN);
        })),

        Container(height: 12),

        _SlideIn(animation: _animations[2], child: _TextField(key: passKey, validate: _validatePass, onChanged: (s) => _pass = s, focusNode: _passFN, obscure: true, label: 'Password', onEditingComplete: () => _passFN.unfocus())),

        Container(height: 16),

        _SlideIn(animation: _animations[3], child: GestureDetector(
          onTap: _submit,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10) ]
            ),
            child: Center(child: Text('Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))),
          ),
        )),

        Container(height: 14),

        _SlideIn(animation: _animations[4], child: GestureDetector(onTap: () {}, child: Text('Forgot Password', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff3e74ed))))),

        Container(height: 35),

        _SlideIn(animation: _animations[5], child: Row(children: [
          _SocialButton('assets/img/fb.svg'),
          Container(width: 25),
          _SocialButton('assets/img/google.svg')
        ])),

        Container(height: 15)
      ])
    ));
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    _loginFN.dispose();
    _passFN.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}


// Sign Up
class _SignUp extends StatefulWidget {
  final TabController controller;
  _SignUp(this.controller);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<_SignUp> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(children: <Widget>[
      _SignUpAccountPage(widget.controller, () => _controller.animateToPage(1, duration: Duration(milliseconds: 450), curve: Curves.easeInOutCubic)),
      _SignUpPhonePage(() => _controller.animateToPage(1, duration: Duration(milliseconds: 450), curve: Curves.easeInOutCubic)),
      _SignUpPhoneVerificationPage()
    ], controller: _controller, physics: NeverScrollableScrollPhysics());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


bool _signUpPlayed = false;
class _SignUpAccountPage extends StatefulWidget {
  final TabController tabController;
  final Function submit;
  _SignUpAccountPage(this.tabController, this.submit);

  @override
  _SignUpAccountPageState createState() => _SignUpAccountPageState();
}

// TODO focus change -> scroll?
class _SignUpAccountPageState extends State<_SignUpAccountPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  String email = "", login = "", pass = "";
  FocusNode emailFN = FocusNode(), loginFN = FocusNode(), passFN = FocusNode();
  double _overlap = 0;
  List<Animation> _animations;
  List<AnimationController> _controllers;
  ScrollController _scrollController;
  GlobalKey emailKey = GlobalKey(), loginKey = GlobalKey(), passKey = GlobalKey();

  @override
  void initState() {
    emailFN.addListener(() => setState(() {}));
    loginFN.addListener(() => setState(() {}));
    passFN.addListener(() => setState(() {}));

    _controllers = List.generate(7, (i) => AnimationController(vsync: this, duration: Duration(milliseconds: 1000)));
    _animations = List.generate(7, (i) => CurvedAnimation(curve: Curves.easeOutExpo, parent: _controllers[i]));
    if(_signUpPlayed) _controllers.forEach((c) => c.value = 1);
    
    _scrollController = ScrollController();

    WidgetsBinding.instance..addObserver(this)..addPostFrameCallback((_) => _startAnimations());

    super.initState();
  }

  bool _validateEmail() => isEmail(email);
  bool _validateLogin() => login.length >= 6;
  bool _validatePass() => pass.length >= 6;
//  double _emailPosition() => (emailKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, _scrollController.offset - 400)).dy;
  double _loginPosition() => (loginKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, _scrollController.offset - 400)).dy;
  double _passPosition() => (passKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, _scrollController.offset - 400)).dy;

  void _startAnimations() async {
    if(_signUpPlayed) return;

    for(int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward(from: 0);
      await Future.delayed(Duration(milliseconds: 200));
    }

    _signUpPlayed = true;
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

  void _signUp() async {
    if(!_validateEmail()) return;
    if(!_validateLogin()) return;
    if(!_validatePass()) return;

    widget.submit();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(controller: _scrollController, padding: EdgeInsets.only(bottom: _overlap), child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(height: 61),

        _SlideIn(animation: _animations[0], child: Text('Create account', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Color(0xff1a1a1a)))),

        Container(height: 43),

        _SlideIn(animation: _animations[1], child: _TextField(key: emailKey, validate: _validateEmail, onChanged: (s) => email = s, focusNode: emailFN, label: 'Email', onEditingComplete: () {
          emailFN.unfocus();
          FocusScope.of(context).requestFocus(loginFN);
          _scrollController.animateTo(_loginPosition(), duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
        })),

        Container(height: 12),

        _SlideIn(animation: _animations[2], child: _TextField(key: loginKey, validate: _validateLogin, onChanged: (s) => login = s, focusNode: loginFN, label: 'Username', onEditingComplete: () {
          loginFN.unfocus();
          FocusScope.of(context).requestFocus(passFN);
          _scrollController.animateTo(_passPosition(), duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
        })),

        Container(height: 12),

        _SlideIn(animation: _animations[3], child: _TextField(key: passKey, validate: _validatePass, onChanged: (s) => pass = s, focusNode: passFN, label: 'Password', obscure: true, onEditingComplete: () => passFN.unfocus())),

        Container(height: 16),

        _SlideIn(animation: _animations[4], child: GestureDetector(
          onTap: _signUp,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10) ]
            ),
            child: Center(child: Text('Sign Up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))),
          ),
        )),

        Container(height: 14),

        _SlideIn(animation: _animations[5], child: GestureDetector(onTap: () => widget.tabController.animateTo(0), child: Text('Have an account', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff3e74ed))))),

        Container(height: 35),

        _SlideIn(animation: _animations[6], child: Row(children: [
          _SocialButton('assets/img/fb.svg'),
          Container(width: 25),
          _SocialButton('assets/img/google.svg')
        ])),

        Container(height: 15)
      ])
    ));
  }

  @override
  void dispose() {
    loginFN.dispose();
    passFN.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _SignUpPhonePage extends StatefulWidget {
  final Function submit;
  const _SignUpPhonePage(this.submit);

  @override
  _SignUpPhonePageState createState() => _SignUpPhonePageState();
}

class _SignUpPhonePageState extends State<_SignUpPhonePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  String code = "", number = "";
  FocusNode codeFN = FocusNode(), numberFN = FocusNode();
  double _overlap = 0;
  ScrollController _scrollController;
  GlobalKey codeKey = GlobalKey(), numberKey = GlobalKey();
  GlobalKey<_TextFieldState> codeEA = GlobalKey(), numberEA = GlobalKey();

  @override
  void initState() {
    codeFN.addListener(() => setState(() {}));
    numberFN.addListener(() => setState(() {}));

    _scrollController = ScrollController();

    super.initState();
  }

  bool _validateCode() => !(code.isEmpty || number.length < 2);
  bool _validateNumber() => !(number.isEmpty || number.length < 9);
//  double _codePosition() => (codeKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, _scrollController.offset - 400)).dy;
  double _numberPosition() => (numberKey.currentContext.findRenderObject() as RenderBox).localToGlobal(Offset(0, _scrollController.offset - 400)).dy;

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

  void _submit() async {
    if(!_validateCode()) codeEA.currentState.shake();
    if(!_validateNumber()) numberEA.currentState.shake();

    widget.submit();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(controller: _scrollController, padding: EdgeInsets.only(bottom: _overlap), child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(height: 61),

        Text('Enter your mobile\nnumber', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Color(0xff1a1a1a))),

        Container(height: 27),

        _TextField(validate: _validateNumber, onChanged: (s) => code = s, focusNode: codeFN, label: 'Country Code', onEditingComplete: () {
          codeFN.unfocus();
          FocusScope.of(context).requestFocus(numberFN);
          _scrollController.animateTo(_numberPosition(), duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
        }),

        Container(height: 12),

        _TextField(validate: _validateNumber, onChanged: (s) => number = s, focusNode: numberFN, label: 'Mobile Number', onEditingComplete: () => numberFN.unfocus()),

        Container(height: 16),

        GestureDetector(
          onTap: _submit,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(1, 7), blurRadius: 10) ]
            ),
            child: Center(child: Text('Sign Up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))),
          ),
        ),

        Container(height: 14),

        GestureDetector(onTap: () {}, child: Text('Resend Code', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff3e74ed)))),

        Container(height: 35),

        Row(children: [
          _SocialButton('assets/img/fb.svg'),
          Container(width: 25),
          _SocialButton('assets/img/google.svg')
        ]),

        Container(height: 15)
      ])
    ));
  }

  @override
  void dispose() {
    codeFN.dispose();
    numberFN.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

// Helpers
class _Tab extends StatefulWidget {
  final String text;
  final int index;
  final TabController controller;
  _Tab(this.text, this.index, this.controller);

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<_Tab> {
  @override
  void initState() {
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: TextStyle(color: widget.controller.index != widget.index ? Color(0xffb3b3b3) : Colors.black, fontWeight: FontWeight.w500, fontSize: 14));
  }
}

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

class _SlideIn extends StatelessWidget {
  final Widget child;
  final Animation animation;
  const _SlideIn({@required this.child, @required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Opacity(opacity: animation.value, child: Transform.translate(offset: Offset(0, lerpDouble(125, 0, animation.value)), child: child)),
        child: child
    );
  }
}

class _TextField extends StatefulWidget {
  final Function validate, onChanged, onEditingComplete;
  final FocusNode focusNode;
  final bool obscure;
  final String label;
  const _TextField({ @required this.validate, @required this.onChanged, @required this.onEditingComplete, @required this.focusNode, @required this.label, this.obscure = false, GlobalKey key }) : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> with TickerProviderStateMixin {
  Animation _shakeAnimation, _labelAnimation;
  AnimationController _shakeController, _labelController;
  String text = "";
  bool lastFocus = false;

  @override
  void initState() {
    _shakeController = AnimationController(vsync: this, duration: Duration(milliseconds: 100))..addStatusListener((s) {
      if(s == AnimationStatus.completed) _shakeController.forward(from: 0);
    });
    _shakeAnimation = Tween<Offset>(begin: Offset(-2, 20), end: Offset(2, 20)).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut));

    _labelController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _labelAnimation = CurvedAnimation(curve: Curves.easeInOutCubic, parent: _labelController);

    widget.focusNode.addListener(() {
      if(!widget.focusNode.hasFocus && lastFocus && text.isEmpty) _labelController.reverse();
      if(widget.focusNode.hasFocus && !lastFocus) _labelController.forward();

      lastFocus = widget.focusNode.hasFocus;
    });

    super.initState();
  }

  Future shake() async {
    _shakeController.forward();
    await Future.delayed(Duration(milliseconds: 500));
    _shakeController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 60, child: Stack(children: [
      AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (c, _) => Transform.translate(offset: _shakeAnimation.value, child: Container(
          height: 40,
          decoration: BoxDecoration(boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(7, 7), blurRadius: 15, spreadRadius: -6) ]),
          child: TextField(
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: (text.isEmpty || widget.validate()) ? BorderSide.none : BorderSide(color: Color(0xffff0000), width: 1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: (text.isEmpty || widget.validate()) ? BorderSide.none : BorderSide(color: Color(0xffff0000), width: 1)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: (text.isEmpty || widget.validate()) ? BorderSide.none : BorderSide(color: Color(0xffff0000), width: 1)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
              suffixIcon: widget.validate() ? SvgPicture.asset('assets/img/tick.svg', width: 8.5, fit: BoxFit.scaleDown) : null
            ),
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: 12, color: Color(0xff1a1a1a)),
            obscureText: widget.obscure,
            onChanged: (s) {
              text = s;
              widget.onChanged(s);
            },
            onEditingComplete: () => setState(() => widget.onEditingComplete()),
          )
        ))
      ),

      AnimatedBuilder(
        animation: _labelAnimation,
        builder: (c, child) => Transform.translate(
          offset: Offset(lerpDouble(15, 0, _labelAnimation.value), lerpDouble(31.5, 0, _labelAnimation.value)),
          child: Text(widget.label, style: TextStyle(
            fontSize: lerpDouble(12, 10, _labelAnimation.value),
            fontWeight: _labelAnimation.value < 0.5 ? FontWeight.w400 : FontWeight.w500,
            color: _labelAnimation.value < 0.5 ? Color(0xff1a1a1a) : Color(0xff666666)
          ))
        )
      )
    ]));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _labelController.dispose();
    super.dispose();
  }
}
