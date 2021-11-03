import 'package:flutter/material.dart';

class ShinyTriangle extends StatelessWidget {
  const ShinyTriangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrianglePainter(),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final LinearGradient gradient = LinearGradient(
      colors: <Color>[
        const Color(0xff4e49ff).withAlpha(50),
        const Color(0xff6d7cff).withAlpha(50),
      ],
      begin: const Alignment(0.2, 1.2),
      end: const Alignment(0.6, 0.75),
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTRB(0, 0, size.width, size.height),
      );

    // Create triangle path.
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
