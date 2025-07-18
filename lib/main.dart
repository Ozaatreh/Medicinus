import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicinus/auth/auth_check.dart';
import 'package:medicinus/pages/medicin_details.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
      'resource://drawable/medical_icon',
    [
      NotificationChannel(
        channelKey: 'medicine_reminders',
        channelName: 'Medicine Reminders',
        channelDescription: 'Reminds you to take your medicine',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
      )
    ],
    debug: true,
  );

// Debug: Print notification permission status
final allowed = await AwesomeNotifications().isNotificationAllowed();
print('Notification allowed: $allowed');

// Debug: List all channels
// final channels = await AwesomeNotifications().listChannels();
// print('Notification channels: $channels');

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // Set listener
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}


Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  final payload = receivedAction.payload;
  final String? medicineId = payload?['medicineId'];

  final user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.email;

  if (medicineId != null && userId != null) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => MedicineDetailsPage(
          medicineId: medicineId,
          userId: userId,
        ),
      ),
    );
  } else {
    print('⚠️ Missing medicineId or user not logged in.');
  }
}
