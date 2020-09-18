import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'welcome.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _anim;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1750))..addListener(() {
      try {
        if (_anim.isCompleted) Future.delayed(Duration(milliseconds: 500), () => _controller.forward(from: 0));
        setState(() {});
      } catch(e) {}
    });
    _anim = CurvedAnimation(curve: Curves.easeInOutExpo, parent: _controller);

    Future.delayed(Duration(seconds: 5), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c) => Welcome())));
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
    super.initState();
  }

  double _getOffset() {
    if(_anim.value <= 0.5) return lerpDouble(0, (MediaQuery.of(context).size.width / 2) + 400, _anim.value);

    return lerpDouble((-MediaQuery.of(context).size.width / 2) - 400, 0, _anim.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: <Widget>[
        Positioned(
          top: (MediaQuery.of(context).size.height / 2) - 50,
          left: ((MediaQuery.of(context).size.width / 2) - 75) + _getOffset(),
          child: SvgPicture.asset('assets/img/logo.svg', height: 100)
        ),

        Positioned(
          left: 0,
          bottom: 0,
          width: 200,
          height: 200,
          child: CustomPaint(size: Size(200, 200), painter: _TrianglePainter()),
        )
      ]),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }
}

class _TrianglePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(colors: <Color>[
      Color(0xff4e49ff).withAlpha(50),
      Color(0xff6d7cff).withAlpha(50)
    ], begin: Alignment(0.2, 1.2), end: Alignment(0.6, 0.75));
    final Paint paint = Paint()..shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    final Path p = Path();

    p.moveTo(0, 0);
    p.lineTo(size.width, size.height);
    p.lineTo(0, size.height);
    p.close();
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}