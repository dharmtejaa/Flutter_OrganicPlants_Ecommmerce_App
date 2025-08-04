import 'package:flutter/material.dart';

class GestureDetectorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;

  const GestureDetectorButton({
    super.key,
    required this.onPressed,
    this.text = 'Skip',
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: textTheme.bodyLarge?.copyWith(
            color:
                colorScheme.brightness == Brightness.dark
                    ? textColor
                    : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
