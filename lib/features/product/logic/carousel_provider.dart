import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselProvider with ChangeNotifier {
  int _activeIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int get activeIndex => _activeIndex;
  CarouselSliderController get carouselController => _carouselController;

  void setIndex(int index) {
    _activeIndex = index;
    notifyListeners();
  }

  void animateToPage(int index) {
    _carouselController.animateToPage(index);
    setIndex(index);
  }
}
