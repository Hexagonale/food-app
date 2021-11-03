import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyTextFormField extends FormField<String> {
  MyTextFormField({
    Key? key,
    required String label,
    required TextEditingController controller,
    required String? Function(String? value) validator,
    required Function() onEditingComplete,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    bool obscure = false,
  }) : super(
          key: key,
          builder: (FormFieldState<String> state) => _MyTextFormField(
            state: state,
            controller: controller,
            label: label,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            textInputAction: textInputAction,
            obscure: obscure,
          ),
          validator: validator,
        );
}

class _MyTextFormField extends StatefulWidget {
  const _MyTextFormField({
    Key? key,
    required this.state,
    required this.controller,
    required this.onEditingComplete,
    required this.focusNode,
    required this.textInputAction,
    required this.label,
    required this.obscure,
  }) : super(key: key);

  final FormFieldState<String> state;
  final TextEditingController controller;
  final Function() onEditingComplete;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool obscure;
  final String label;

  @override
  __MyTextFormFieldState createState() => __MyTextFormFieldState();
}

class __MyTextFormFieldState extends State<_MyTextFormField> with TickerProviderStateMixin {
  static const double labelHeight = 20.0;
  static const double fieldHeight = 40.0;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final CurvedAnimation _shakeAnimation = CurvedAnimation(
    curve: Curves.elasticInOut,
    parent: _shakeController,
  );

  late final AnimationController _labelController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late final CurvedAnimation _labelAnimation = CurvedAnimation(
    curve: Curves.easeInOutCubic,
    parent: _labelController,
  );

  final FocusNode _fallbackFocusNode = FocusNode();

  String? lastError;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_focusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusChanged);

    _shakeController.dispose();
    _labelController.dispose();
    _fallbackFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (lastError != widget.state.errorText) {
      _errorChanged(
        lastError: lastError,
        currentError: widget.state.errorText,
      );

      lastError = widget.state.errorText;
    }

    return SizedBox(
      height: labelHeight + fieldHeight,
      child: Stack(
        children: <Widget>[
          _buildAnimatedTextField(),
          _buildLabel(),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField() {
    final Animation<Offset> shakeOffset = Tween<Offset>(
      begin: const Offset(-2, 0.0),
      end: const Offset(2, 0.0),
    ).animate(_shakeAnimation);

    return Positioned.fill(
      top: labelHeight,
      child: AnimatedBuilder(
        animation: shakeOffset,
        child: _buildTextField(),
        builder: (BuildContext c, Widget? child) {
          return Transform.translate(
            offset: shakeOffset.value,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      height: fieldHeight,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(1.0, 7.0),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          )
        ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
          suffixIcon: _icon,
        ),
        textInputAction: widget.textInputAction,
        style: const TextStyle(
          fontSize: 12.0,
          color: Color(0xff1a1a1a),
        ),
        obscureText: widget.obscure,
        onChanged: widget.state.didChange,
        onEditingComplete: widget.onEditingComplete,
      ),
    );
  }

  Widget _buildLabel() {
    const Rect begin = Rect.fromLTRB(16.0, labelHeight, 0.0, 0.0);
    const Rect end = Rect.fromLTRB(8.0, 0.0, 0.0, fieldHeight);

    return AnimatedBuilder(
      animation: _labelAnimation,
      builder: (BuildContext context, Widget? child) {
        final Rect rect = Rect.lerp(begin, end, _labelAnimation.value)!;

        final double fontSize = lerpDouble(12, 10, _labelAnimation.value)!;
        final FontWeight fontWeight = _labelAnimation.value < 0.5 ? FontWeight.w400 : FontWeight.w500;
        final Color textColor = Color.lerp(
          const Color(0xff1a1a1a),
          const Color(0xff666666),
          _labelAnimation.value,
        )!;

        return Positioned.fill(
          top: rect.top,
          left: rect.left,
          right: rect.right,
          bottom: rect.bottom,
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _shake() async {
    _shakeController.repeat();
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    _shakeController.stop();
  }

  void _focusChanged() {
    if (widget.controller.text.isNotEmpty) {
      // Do not move label back in field when there's text.
      return;
    }

    _focusNode.hasFocus ? _labelController.forward() : _labelController.reverse();
  }

  void _errorChanged({
    required String? lastError,
    required String? currentError,
  }) {
    if (lastError == currentError) {
      // No change.
      return;
    }

    if (currentError == null) {
      // No error.
      return;
    }

    _shake();
  }

  FocusNode get _focusNode {
    return widget.focusNode ?? _fallbackFocusNode;
  }

  OutlineInputBorder get _border {
    if (!widget.state.hasError) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      );
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Color(0xffff0000),
        width: 1,
      ),
    );
  }

  Widget? get _icon {
    if (widget.state.hasError) {
      return null;
    }

    return SvgPicture.asset(
      'assets/img/tick.svg',
      width: 8.5,
      fit: BoxFit.scaleDown,
    );
  }
}
