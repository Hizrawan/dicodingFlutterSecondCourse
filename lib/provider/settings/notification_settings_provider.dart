import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/services/local_notification_service.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  final LocalNotificationService notificationService;
  
  NotificationSettingsProvider(this.notificationService) {
    _loadSettings();
  }

  bool _notificationsEnabled = true;
  bool _dailyNotificationEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 10, minute: 0);
  String _frequency = 'daily'; // daily, weekly, monthly

  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyNotificationEnabled => _dailyNotificationEnabled;
  TimeOfDay get notificationTime => _notificationTime;
  String get frequency => _frequency;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    _dailyNotificationEnabled = prefs.getBool('daily_notification_enabled') ?? false;
    _frequency = prefs.getString('notification_frequency') ?? 'daily';
    
    final hour = prefs.getInt('notification_hour') ?? 10;
    final minute = prefs.getInt('notification_minute') ?? 0;
    _notificationTime = TimeOfDay(hour: hour, minute: minute);
    
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    
    if (!enabled) {
      await _cancelAllScheduledNotifications();
    }
    
    notifyListeners();
  }

  Future<void> setDailyNotificationEnabled(bool enabled) async {
    _dailyNotificationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', enabled);
    
    if (enabled && _notificationsEnabled) {
      await _scheduleNotification();
    } else {
      await _cancelAllScheduledNotifications();
    }
    
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', time.hour);
    await prefs.setInt('notification_minute', time.minute);
    
    if (_dailyNotificationEnabled && _notificationsEnabled) {
      await _scheduleNotification();
    }
    
    notifyListeners();
  }

  Future<void> setFrequency(String frequency) async {
    _frequency = frequency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_frequency', frequency);
    
    if (_dailyNotificationEnabled && _notificationsEnabled) {
      await _scheduleNotification();
    }
    
    notifyListeners();
  }

  Future<void> _scheduleNotification() async {
    // Cancel existing scheduled notifications
    await _cancelAllScheduledNotifications();
    
    if (!_notificationsEnabled || !_dailyNotificationEnabled) return;

    // Calculate next notification time
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      _notificationTime.hour,
      _notificationTime.minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Calculate delay in minutes
    final delay = scheduledTime.difference(now).inMinutes;

    // Schedule with WorkManager
    await notificationService.scheduleWorkManagerNotification(
      initialDelay: Duration(minutes: delay),
      frequency: _getWorkManagerFrequency(),
    );
  }

  Duration _getWorkManagerFrequency() {
    switch (_frequency) {
      case 'daily':
        return const Duration(hours: 24);
      case 'weekly':
        return const Duration(days: 7);
      case 'monthly':
        return const Duration(days: 30);
      default:
        return const Duration(hours: 24);
    }
  }

  Future<void> _cancelAllScheduledNotifications() async {
    await notificationService.cancelWorkManagerNotifications();
  }

  Future<void> testNotification() async {
    if (_notificationsEnabled) {
      await notificationService.showBigPictureNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: "🍽️ Test Notification",
        body: "Ini adalah notifikasi test dari pengaturan",
        payload: "test-notification",
      );
    }
  }
}
