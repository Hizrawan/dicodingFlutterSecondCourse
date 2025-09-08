import 'package:flutter/widgets.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  bool get isLastPage => _currentPage == 2; // Assuming 3 pages (0, 1, 2)
}
