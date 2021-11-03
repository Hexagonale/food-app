import 'package:flutter/material.dart';
import 'package:foodapp/widgets/_widgets.dart';

import '../widgets/_widgets.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function() onSubmit;

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 61.0),
            const Text(
              'Verify your mobile number',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w500,
                color: Color(0xff1a1a1a),
              ),
            ),
            const SizedBox(height: 61.0),
            CodeInput(
              controller: _codeController,
            ),
            const SizedBox(height: 13.0),
            const Text(
              'Enter your 4 digit code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Color(0xff666666),
              ),
            ),
            const SizedBox(height: 32.0),
            MyButton(
              text: 'Continue',
              onPressed: () => _submit(context),
            ),
            const SizedBox(height: 32.0),
            MyTextButton(
              text: 'Resend Code',
              onPressed: () {},
            ),
            const SizedBox(height: 15.0)
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final String code = _codeController.text;
    if (code.trim().length < 4 || int.tryParse(code) == null) {
      return;
    }

    widget.onSubmit();
  }
}
