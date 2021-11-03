import 'package:flutter/material.dart';

import 'pages/_pages.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  final Function() onLoginTapped;

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
        AccountPage(
          onSubmit: _goToNextPage,
          onLogin: widget.onLoginTapped,
        ),
        PhonePage(
          onSubmit: _goToNextPage,
        ),
        const VerificationPage(),
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
