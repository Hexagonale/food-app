import 'package:flutter/material.dart';
import 'package:foodapp/my_icons.dart';
import 'package:foodapp/widgets/_widgets.dart';

class SocialButtonRow extends StatelessWidget {
  const SocialButtonRow({
    Key? key,
    required this.onFacebookPressed,
    required this.onGooglePressed,
  }) : super(key: key);

  final Function() onFacebookPressed;
  final Function() onGooglePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        MyIconButton(
          icon: MyIcons.facebook,
          onPressed: onFacebookPressed,
        ),
        const SizedBox(width: 25.0),
        MyIconButton(
          icon: MyIcons.google,
          onPressed: onGooglePressed,
        )
      ],
    );
  }
}
