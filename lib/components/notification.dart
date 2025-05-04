import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicinus/main.dart';
import 'package:medicinus/pages/medicin_details.dart';

class NotificationService {
  // Request permissions when the app starts
  static Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Initialize the notification system
  static void initialize() {
    AwesomeNotifications().initialize(
      'resource://drawable/medical_icon',
      [
        NotificationChannel(
          channelKey: 'medicine_reminders',
          channelName: 'Medicine Reminders',
          channelDescription: 'Reminds you to take your medicine',
          defaultColor: const Color(0xFF2196F3),
          ledColor: const Color(0xFFFFFFFF),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        )
      ],
      debug: true,
    );
  }

  // Schedule a notification
  static Future<void> scheduleNotification(
      int id, String medicineName, DateTime time, String medicineId) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'medicine_reminders',
        title: 'Time to take your medicine',
        body: 'Don’t forget to take $medicineName!',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        autoDismissible: true,
        locked: false,
        payload: {'medicineId': medicineId}, // Pass the medicineId in the payload
      ),
      schedule: NotificationCalendar(
        year: time.year,
        month: time.month,
        day: time.day,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        allowWhileIdle: true,
        repeats: false,
      ),
    );
  }

  // Handle notification tap
  static Future<void> onNotificationTap(ReceivedAction receivedAction) async {
    final medicineId = receivedAction.payload?['medicineId'];
    if (medicineId != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MedicineDetailsPage(medicineId: medicineId),
        ),
      );
    }
  }

  // Listen to notification actions (e.g., tap on notification)
  static void handleNotificationClick() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationTap,
    );
  }
}
