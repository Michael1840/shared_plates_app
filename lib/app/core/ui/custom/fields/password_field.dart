import 'package:flutter/material.dart';

import 'my_form_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final void Function(String)? onSubmit;
  final TextInputAction? textAction;
  const PasswordField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.onSubmit,
    this.textAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return MyFormField(
      controller: widget.controller,
      hint: widget.hint,
      title: widget.title,
      icon: Icons.lock_rounded,
      isRequired: true,
      onSubmit: widget.onSubmit,
      obscureText: _isObscured,
      textAction: widget.textAction,
      trailingIcon: IconButton(
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
        icon: Icon(
          !_isObscured
              ? Icons.remove_red_eye_rounded
              : Icons.remove_red_eye_outlined,
        ),
      ),
    );
  }
}
