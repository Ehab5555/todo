import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class DefaultTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isPassword;
  const DefaultTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.isPassword = false,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool isObsecure = false;
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
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: Icon(
                  isObsecure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
      ),
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      maxLines: widget.maxLines,
      obscureText: isObsecure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
