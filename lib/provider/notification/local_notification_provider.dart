import 'package:flutter/widgets.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/services/api_service.dart';
import 'dart:math';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final ApiServices apiService;

  LocalNotificationProvider(this.flutterNotificationService, this.apiService);

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "Kamu sudah makan belum?",
      body: "This is a new notification with id $_notificationId",
      payload: "This is a payload from notification with id $_notificationId",
    );
  }

  Future<void> showBigPictureNotification() async {
    _notificationId += 1;
    
    try {
      // Fetch restaurant list from API
      final result = await apiService.getRestaurantList();
      
      if (result is Success) {
        final successResult = result as Success;
        final restaurants = successResult.value.restaurants;
        if (restaurants.isNotEmpty) {
          // Select a random restaurant
          final randomRestaurant = restaurants[Random().nextInt(restaurants.length)];
          final imageUrl = randomRestaurant.imageUrl;
          
          flutterNotificationService.showBigPictureNotification(
            id: _notificationId,
            title: "Ayo Coba makan di ${randomRestaurant.name}",
            body: "Rating: ${randomRestaurant.rating} ⭐ | ${randomRestaurant.city}",
            payload: "Big picture notification with id $_notificationId",
            imageUrl: imageUrl,
          );
          return;
        }
      }
    } catch (e) {
      // Fallback to static picture IDs if API fails
    }
    
    // Fallback: Use static picture IDs if API fails
    final List<String> restaurantPictureIds = [
      "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"
    ];
    
    final randomPictureId = restaurantPictureIds[Random().nextInt(restaurantPictureIds.length)];
    final imageUrl = "https://restaurant-api.dicoding.dev/images/large/$randomPictureId";
    
    flutterNotificationService.showBigPictureNotification(
      id: _notificationId,
      title: "🍽️ Restoran Favorit Menunggumu!",
      body: "Temukan restoran terbaik di sekitarmu dengan menu lezat dan rating tinggi",
      payload: "Big picture notification with id $_notificationId",
      imageUrl: imageUrl,
    );
  }
}
