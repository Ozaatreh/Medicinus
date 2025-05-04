import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicinus/components/noti_controler.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  // Add this to a button in your app (e.g., settings page or debug menu):
ElevatedButton(
  onPressed: () async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print('❌ No user logged in!');
      return;
    }

    // Schedule for 10 seconds from now
    final testTime = DateTime.now().add(Duration(seconds: 10));

    await NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
      medicineName: 'TEST IBUPROFEN',
      time: testTime,
      medicineId: 'test-ibuprofen-123',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test notification scheduled for $testTime')),
    );

    // Debug: Print pending notifications
    await NotificationService.debugPrintScheduledNotifications();
  },
  child: Text('TEST NOTIFICATION'),
);
  }
}