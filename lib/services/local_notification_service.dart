import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:restaurant_app/services/api_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final notificationEnabled = await _isAndroidPermissionGranted();
      await _requestExactAlarmsPermission();
      if (!notificationEnabled) {
        final requestNotificationsPermission =
            await _requestAndroidNotificationsPermission();
        return requestNotificationsPermission;
      }
      return notificationEnabled;
    } else {
      return false;
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    String channelId = "1",
    String channelName = "Simple Notification",
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showBigPictureNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    String? imagePath,
    String? imageUrl,
    String channelId = "2",
    String channelName = "Big Picture Notification",
  }) async {
    BigPictureStyleInformation? styleInformation;

    if (imageUrl != null) {
      // Use network image
      try {
        final http.Response response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final Uint8List imageBytes = response.bodyBytes;
          styleInformation = BigPictureStyleInformation(
            ByteArrayAndroidBitmap(imageBytes),
            largeIcon: ByteArrayAndroidBitmap(imageBytes),
            contentTitle: title,
            htmlFormatContentTitle: true,
            summaryText: body,
            htmlFormatSummaryText: true,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading network image: $e');
        }
      }
    }

    // Fallback to local asset if network image fails or not provided
    if (styleInformation == null) {
      final List<String> restaurantImages = [
        "assets/images/laptop-2298286_1280.png",
        "assets/images/pixel-cells-3947911_1280.png",
        "assets/images/social-media-3846597_1280.png",
      ];

      final String selectedImage =
          imagePath ??
          restaurantImages[Random().nextInt(restaurantImages.length)];
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(selectedImage),
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: styleInformation,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDailyTenAMNotification({
    required int id,
    String channelId = "3",
    String channelName = "Schedule Notification",
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final datetimeSchedule = _nextInstanceOfTenAM();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Daily scheduled notification title',
      'This is a body of daily scheduled notification',
      datetimeSchedule,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // WorkManager methods
  Future<void> initializeWorkManager() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  Future<void> scheduleWorkManagerNotification({
    required Duration initialDelay,
    required Duration frequency,
  }) async {
    await Workmanager().registerPeriodicTask(
      "restaurant-notification",
      "restaurant-notification-task",
      frequency: frequency,
      initialDelay: initialDelay,
    );
  }

  Future<void> cancelWorkManagerNotifications() async {
    await Workmanager().cancelAll();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await _sendRestaurantNotification();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

Future<void> _sendRestaurantNotification() async {
  try {
    final notificationService = LocalNotificationService();
    final apiService = ApiServices();
    
    // Fetch restaurant list from API
    final result = await apiService.getRestaurantList();
    
    if (result is Success) {
      final successResult = result as Success;
      final restaurants = successResult.value.restaurants;
      
      if (restaurants.isNotEmpty) {
        // Select a random restaurant
        final randomRestaurant = restaurants[Random().nextInt(restaurants.length)];
        final imageUrl = randomRestaurant.imageUrl;
        
        // Send big picture notification
        await notificationService.showBigPictureNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "🍽️ ${randomRestaurant.name}",
          body: "Rating: ${randomRestaurant.rating} ⭐ | ${randomRestaurant.city}",
          payload: "scheduled-notification",
          imageUrl: imageUrl,
        );
      }
    } else {
      // Fallback: Use static picture IDs if API fails
      final List<String> restaurantPictureIds = [
        "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"
      ];
      
      final randomPictureId = restaurantPictureIds[Random().nextInt(restaurantPictureIds.length)];
      final imageUrl = "https://restaurant-api.dicoding.dev/images/large/$randomPictureId";
      
      await notificationService.showBigPictureNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: "🍽️ Restoran Favorit Menunggumu!",
        body: "Temukan restoran terbaik di sekitarmu dengan menu lezat dan rating tinggi",
        payload: "scheduled-notification",
        imageUrl: imageUrl,
      );
    }
  } catch (e) {
    // Handle error silently
    if (kDebugMode) {
      print('Error in notification worker: $e');
    }
  }
}
