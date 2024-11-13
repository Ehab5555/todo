import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class DefaultTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  const DefaultTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppTheme.black,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
          ),
        ),
        hintText: hintText,
      ),
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
