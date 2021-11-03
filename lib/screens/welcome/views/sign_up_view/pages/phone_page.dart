import 'package:flutter/material.dart';
import 'package:foodapp/widgets/_widgets.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function() onSubmit;

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _numberController.dispose();
    _codeFocusNode.dispose();
    _numberFocusNode.dispose();

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
              'Enter your mobile number',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w500,
                color: Color(0xff1a1a1a),
              ),
            ),
            const SizedBox(height: 27.0),
            MyTextFormField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              validator: _validateCode,
              label: 'Country Code',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onEditingComplete: () {
                _codeFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_numberFocusNode);
              },
            ),
            const SizedBox(height: 12.0),
            MyTextFormField(
              controller: _numberController,
              focusNode: _numberFocusNode,
              validator: _validateNumber,
              label: 'Mobile Number',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              onEditingComplete: _numberFocusNode.unfocus,
            ),
            const SizedBox(height: 16.0),
            MyButton(
              text: 'Continue',
              onPressed: _submit,
            ),
            const SizedBox(height: 15.0)
          ],
        ),
      ),
    );
  }

  String? _validateNumber(String? number) {
    if (number == null) {
      return 'Number cannot be empty.';
    }

    if (number.isEmpty) {
      return 'Number cannot be empty.';
    }

    if (number.trim().length < 9) {
      return 'Number has t have 9 letters.';
    }

    return null;
  }

  String? _validateCode(String? code) {
    if (code == null) {
      return 'Country code cannot be empty.';
    }

    if (code.isEmpty) {
      return 'Country code cannot be empty.';
    }

    if (code.length < 2) {
      return 'Country must be at least 2 digits.';
    }

    return null;
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    widget.onSubmit();
  }
}
