import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = 25.0,
  }) : super(key: key);

  final String icon;
  final Function() onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        icon,
        width: size,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
