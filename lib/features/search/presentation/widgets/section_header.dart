import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showClear;
  final VoidCallback? onClear;

  const SectionHeader({
    super.key,
    required this.title,
    this.showClear = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.headlineSmall),
        if (showClear && onClear != null)
          GestureDetector(
            onTap: onClear,
            child: Text(
              'Clear',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
