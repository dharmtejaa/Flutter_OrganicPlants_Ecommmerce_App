import 'package:flutter/material.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/search/presentation/screens/search_screen.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      child: Icon(
        Icons.search,
        color: colorScheme.onSurface,
        size: AppSizes.iconMd,
      ),
      onTap: () {
        // Clear focus before navigation to prevent keyboard from appearing

        // Implement search functionality
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
    );
  }
}
