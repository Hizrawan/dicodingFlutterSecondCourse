import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/settings/notification_settings_provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        centerTitle: true,
      ),
      body: Consumer<NotificationSettingsProvider>(
        builder: (context, settingsProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifikasi Restoran',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Atur kapan Anda ingin menerima rekomendasi restoran',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Enable Notifications
                Card(
                  child: SwitchListTile(
                    title: const Text('Aktifkan Notifikasi'),
                    subtitle: const Text('Izinkan aplikasi mengirim notifikasi'),
                    value: settingsProvider.notificationsEnabled,
                    onChanged: (value) {
                      settingsProvider.setNotificationsEnabled(value);
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                ),

                const SizedBox(height: 16),

                // Daily Notifications
                Card(
                  child: SwitchListTile(
                    title: const Text('Notifikasi Harian'),
                    subtitle: const Text('Terima rekomendasi restoran setiap hari'),
                    value: settingsProvider.dailyNotificationEnabled,
                    onChanged: settingsProvider.notificationsEnabled
                        ? (value) {
                            settingsProvider.setDailyNotificationEnabled(value);
                          }
                        : null,
                    secondary: const Icon(Icons.schedule),
                  ),
                ),

                const SizedBox(height: 16),

                // Notification Time
                if (settingsProvider.dailyNotificationEnabled)
                  Card(
                    child: ListTile(
                      title: const Text('Waktu Notifikasi'),
                      subtitle: Text(
                        '${settingsProvider.notificationTime.format(context)}',
                      ),
                      leading: const Icon(Icons.access_time),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _selectTime,
                    ),
                  ),

                const SizedBox(height: 16),

                // Frequency
                if (settingsProvider.dailyNotificationEnabled)
                  Card(
                    child: ListTile(
                      title: const Text('Frekuensi'),
                      subtitle: Text(_getFrequencyText(settingsProvider.frequency)),
                      leading: const Icon(Icons.repeat),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _selectFrequency,
                    ),
                  ),

                const SizedBox(height: 24),

                // Test Notification Button
                if (settingsProvider.notificationsEnabled)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await settingsProvider.testNotification();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifikasi test dikirim!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Test Notifikasi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Manual Notification Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<LocalNotificationProvider>().showBigPictureNotification();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Notifikasi Big Picture Manual'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const Spacer(),

                // Info Card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Notifikasi akan tetap berjalan meskipun aplikasi ditutup berkat WorkManager.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectTime() async {
    final settingsProvider = context.read<NotificationSettingsProvider>();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: settingsProvider.notificationTime,
    );
    if (picked != null) {
      settingsProvider.setNotificationTime(picked);
    }
  }

  Future<void> _selectFrequency() async {
    final settingsProvider = context.read<NotificationSettingsProvider>();
    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Frekuensi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Harian'),
                value: 'daily',
                groupValue: settingsProvider.frequency,
                onChanged: (String? value) {
                  Navigator.of(context).pop(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Mingguan'),
                value: 'weekly',
                groupValue: settingsProvider.frequency,
                onChanged: (String? value) {
                  Navigator.of(context).pop(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Bulanan'),
                value: 'monthly',
                groupValue: settingsProvider.frequency,
                onChanged: (String? value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      settingsProvider.setFrequency(selected);
    }
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Setiap hari';
      case 'weekly':
        return 'Setiap minggu';
      case 'monthly':
        return 'Setiap bulan';
      default:
        return 'Setiap hari';
    }
  }
}
