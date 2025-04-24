import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {

  void requestNotificationPermissions() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

  static void initialize() {
    AwesomeNotifications().initialize(
      'resource://drawable/medical_icon', // Default icon
      [
        NotificationChannel(
          channelKey: 'medicine_reminders',
          channelName: 'Medicine Reminders',
          channelDescription: 'Reminds you to take your medicine',
          defaultColor: const Color(0xFF2196F3),
          importance: NotificationImportance.High,
          ledColor: const Color(0xFFFFFFFF),
        )
      ],
      debug: true,
    );
  }

  static Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleNotification(int id, String medicineName, DateTime time) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'medicine_reminders',
        title: 'Time to take your medicine',
        body: 'Don’t forget to take $medicineName!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: time.year,
        month: time.month,
        day: time.day,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        repeats: false,
      ),
    );
  }

  static void cancelNotification(int id) {
    AwesomeNotifications().cancel(id);
  }

  static void handleNotificationClick(Function(ReceivedAction) onNotificationClick) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        onNotificationClick(receivedAction);
      },
    );
  }
}
