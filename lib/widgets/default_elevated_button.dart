import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const DefaultElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 52),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
            ),
      ),
    );
  }
}
