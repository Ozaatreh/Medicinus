import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicinus/main.dart';
import 'package:medicinus/pages/medicin_details.dart';

class NotificationService {
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

  static Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleNotification(
      int id, String medicineName, DateTime time, String medicineId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'medicine_reminders',
        title: 'Time to take your medicine',
        body: "Dont forget to take $medicineName!",
        payload: {
          'medicineId': medicineId,
          'userId': userId,
        },
        wakeUpScreen: true,  // Ensure screen wakes up
        fullScreenIntent: true,  // Show as full screen intent
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

  static void setupNotificationListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        await onNotificationTap(receivedAction);
      },
    );
  }

  static Future<void> onNotificationTap(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload;
    final medicineId = payload?['medicineId'];
    final userId = payload?['userId'];

    if (medicineId != null && userId != null) {
      // Use navigatorKey to push the new route
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MedicineDetailsPage(
            medicineId: medicineId,
            userId: userId,
          ),
        ),
      );
    }
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}