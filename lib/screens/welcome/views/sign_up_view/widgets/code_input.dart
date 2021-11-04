import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            onChanged: _onCodeChanged,
          ),
        ),
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_focusNode),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildDigitInput(
                index: 0,
              ),
              const SizedBox(width: 32.0),
              _buildDigitInput(
                index: 1,
              ),
              const SizedBox(width: 32.0),
              _buildDigitInput(
                index: 2,
              ),
              const SizedBox(width: 32.0),
              _buildDigitInput(
                index: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDigitInput({
    required int index,
  }) {
    String text = '';
    if (index < widget.controller.text.length) {
      text = widget.controller.text.characters.elementAt(index);
    }

    // Field should be highlighted as active only when keyboard is shown and it's currently edited.
    final bool active = _focusNode.hasFocus && widget.controller.text.length == index;

    return IgnorePointer(
      child: Container(
        width: 52.0,
        height: 52.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: active ? Colors.black.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(1.0, 6.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 30.0,
              color: Color(0xff333333),
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );
  }

  void _onCodeChanged(String code) {
    // Check if code isn't longer than 4.
    if (code.length > 4) {
      _removeLastCharacter();
      return;
    }

    // Check if whitespace was introduced.
    if (code.trim() != code) {
      _removeLastCharacter();
      return;
    }

    // Check if code is numeric.
    if (code.isNotEmpty && int.tryParse(code) == null) {
      _removeLastCharacter();
      return;
    }

    // Unfocus when full code is entered.
    if (code.length == 4) {
      _focusNode.unfocus();
    }

    setState(() {});
  }

  void _removeLastCharacter() {
    widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);

    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(
        offset: widget.controller.text.length,
      ),
    );
  }
}
