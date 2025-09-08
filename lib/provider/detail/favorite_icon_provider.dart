import 'package:flutter/widgets.dart';

class FavoriteIconProvider extends ChangeNotifier {
bool _isFavoriteed = false;
bool get isFavoriteed => _isFavoriteed;

  set isFavoriteed(bool value) {
    _isFavoriteed = value;
    notifyListeners();
  }
}