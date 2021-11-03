import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../my_icons.dart';
import '../welcome/welcome.dart';
import 'widgets/shiny_triangle.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  static Route<Widget> getRoute() {
    return MaterialPageRoute<Widget>(
      builder: (BuildContext context) => const Splash(),
    );
  }

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 1750);
  static const Duration _redirectDelay = Duration(seconds: 4);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _animationDuration,
  );

  late final CurvedAnimation _animation = CurvedAnimation(
    curve: Curves.easeInOutExpo,
    parent: _controller,
  );

  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => _init(),
    );
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: <Widget>[
        _buildAnimatedLogo(),
        const Positioned(
          left: 0.0,
          bottom: 0.0,
          width: 200.0,
          height: 200.0,
          child: ShinyTriangle(),
        )
      ]),
    );
  }

  Widget _buildAnimatedLogo() {
    const Size logoSize = Size(125.0, 100.0);
    final Offset logoCenteredPosition = ((MediaQuery.of(context).size - logoSize) as Offset) / 2;

    return AnimatedBuilder(
      animation: _animation,
      child: SizedBox(
        width: logoSize.width,
        height: logoSize.height,
        child: Center(
          child: SvgPicture.asset(
            MyIcons.logo,
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          top: logoCenteredPosition.dy,
          left: logoCenteredPosition.dx + _mapValueToOffset(_animation.value),
          child: child!,
        );
      },
    );
  }

  /// Initializes [_redirectTimer] and start [_animation].
  ///
  /// Should be called after first frame.
  void _init() {
    _redirectTimer = Timer(
      _redirectDelay,
      () => Navigator.pushReplacement(context, Welcome.getRoute()),
    );

    _controller.repeat(
      period: _animationDuration + const Duration(milliseconds: 1000),
    );
  }

  /// Maps [value] to logo offset.
  ///
  /// [value] should be in <0, 1> range.
  /// It's mapped in such way that it starts and ends in center.
  /// Offset is mapped 400 pixels beyond screen boundaries.
  double _mapValueToOffset(double value) {
    final double halfScreenWidth = MediaQuery.of(context).size.width / 2.0;

    // First part of animation - left screen half.
    if (_animation.value <= 0.5) {
      return lerpDouble(
        0.0,
        halfScreenWidth + 400.0,
        _animation.value,
      )!;
    }

    // Second part of animation - right screen half.
    return lerpDouble(
      -halfScreenWidth - 400.0,
      0.0,
      _animation.value,
    )!;
  }
}
