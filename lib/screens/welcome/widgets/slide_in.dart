import 'dart:async';

import 'package:flutter/material.dart';

class SlideIn extends StatefulWidget {
  const SlideIn({
    Key? key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 200),
    this.initialOffset = const Offset(0.0, 125.0),
    this.curve = Curves.easeOutExpo,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  final Widget child;
  final int index;
  final Duration delay;
  final Offset initialOffset;
  final Curve curve;
  final Duration duration;

  @override
  _SlideInState createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );
  late final CurvedAnimation _animation = CurvedAnimation(
    curve: widget.curve,
    parent: _controller,
  );

  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();

    // Start animation after calculated delay.
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _delayTimer = Timer(
        widget.delay * widget.index,
        () => _controller.forward(),
      );
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final Offset offset = Offset.lerp(
          widget.initialOffset,
          Offset.zero,
          _animation.value,
        )!;

        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: offset,
            child: widget.child,
          ),
        );
      },
    );
  }
}
