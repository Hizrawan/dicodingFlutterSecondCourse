import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
   final ApiServices _apiServices;

  RestaurantDetailProvider(
    this._apiServices,
  );
 RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  RestaurantDetailResultState get resultState => _resultState;
 Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantDetail(id);

      switch (result) {
        case Success(value: final restaurantDetailResponse):
          _resultState = RestaurantDetailLoadedState(restaurantDetailResponse.restaurant);
          notifyListeners();
        case Failure(error: final message):
          _resultState = RestaurantDetailErrorState(message);
          notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}