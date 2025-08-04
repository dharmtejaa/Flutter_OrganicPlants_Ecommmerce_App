import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void updatePage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(PageController controller, int totalPages) {
    if (_currentPage < totalPages - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd(PageController controller, int totalPages) {
    controller.jumpToPage(totalPages - 1);
  }
}
