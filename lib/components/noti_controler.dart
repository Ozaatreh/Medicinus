// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:medicinus/main.dart'; // Contains navigatorKey
// import 'package:medicinus/pages/medicin_details.dart';

// class NotificationService {
//   static Future<void> initialize() async {
//     await AwesomeNotifications().initialize(
//       'resource://drawable/medical_icon',
//       [
//         NotificationChannel(
//           channelKey: 'medicine_reminders',
//           channelName: 'Medicine Reminders',
//           channelDescription: 'Reminds you to take your medicine',
//           defaultColor: const Color(0xFF2196F3),
//           ledColor: Colors.white,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           playSound: true,
//           enableLights: true,
//           enableVibration: true,
//           criticalAlerts: true,
//         )
//       ],
//       debug: true,
//     );
//   }

//   static Future<bool> requestPermissions() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) {
//       isAllowed = await AwesomeNotifications()
//           .requestPermissionToSendNotifications();
//     }
//     return isAllowed;
//   }

//   static Future<void> scheduleNotification({
//     required int id,
//     required String medicineName,
//     required DateTime time,
//     required String medicineId,
//   }) async {
//     final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    
//     if (userEmail == null) {
//       print('⚠️ Cannot schedule notification - no user email found');
//       return;
//     }

//     print('⏰ Scheduling notification for:');
//     print('   User: $userEmail');
//     print('   Medicine: $medicineId ($medicineName)');
//     print('   Time: $time');

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'medicine_reminders',
//         title: 'Time to take $medicineName',
//         body: 'Please take your medication as scheduled',
//         payload: {
//           'medicineId': medicineId,
//           'userEmail': userEmail, // Using email consistently
//         },
//         wakeUpScreen: true,
//         locked: true,
//       ),
//       schedule: NotificationCalendar(
//         year: time.year,
//         month: time.month,
//         day: time.day,
//         hour: time.hour,
//         minute: time.minute,
//         second: 0,
//         allowWhileIdle: true,
//         timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//       ),
//     );
//   }

//   static Future<void> onNotificationTap(ReceivedAction receivedAction) async {
//     final payload = receivedAction.payload;
//     final medicineId = payload?['medicineId'];
//     final userEmail = payload?['userEmail'];

//     print('🔔 Notification tapped:');
//     print('   Medicine ID: $medicineId');
//     print('   User Email: $userEmail');

//     if (medicineId != null && userEmail != null) {
//       // Ensure Firebase is initialized
//       await Firebase.initializeApp();

//       // Give time for navigation system to initialize
//       await Future.delayed(const Duration(milliseconds: 300));

//       navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (_) => MedicineDetailsPage(
//             userEmail: userEmail,
//             medicineId: medicineId, 
//           ),
//         ),
//       );
//     } else {
//       print('❌ Missing medicineId or userEmail in payload!');
//       print('Full payload: $payload');
//     }
//   }

//   static void setupNotificationListeners() {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onNotificationTap,
//     );
//   }

//   static Future<void> cancelNotification(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }

//   static Future<void> cancelAllNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }

//   // Debug method to list scheduled notifications
//   static Future<void> debugPrintScheduledNotifications() async {
//     final pending = await AwesomeNotifications().listScheduledNotifications();
//     print('📋 Scheduled Notifications (${pending.length})');
//     for (var n in pending) {
//       final schedule = n.schedule;
//       print('  ID: ${n.content?.id} - ${n.content?.title}');
//       print('  Payload: ${n.content?.payload}');
//       if (schedule is NotificationCalendar) {
//         print('  Scheduled for: ${schedule.hour}:${schedule.minute}');
//       }
//     }
//   }
// }