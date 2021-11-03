import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../my_icons.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  double _logoScale = 0.0;

  @override
  void initState() {
    super.initState();

    // Start animation.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _logoScale = 1.0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      scale: _logoScale,
      child: _buildLogo(),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 65.0,
      height: 65.0,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(17.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1.0, 7.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: SvgPicture.asset(
        MyIcons.logo,
        alignment: Alignment.center,
      ),
    );
  }
}
