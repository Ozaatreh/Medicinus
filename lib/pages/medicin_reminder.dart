import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineReminderPage extends StatefulWidget {
  @override
  _MedicineReminderPageState createState() => _MedicineReminderPageState();
}

class _MedicineReminderPageState extends State<MedicineReminderPage> {
  late Timer _timer;
  late DateTime _now;

  String? medicineName;
  String? doseAmount;
  String? doseUnit;
  String? reminderTime;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    fetchMedicineData(); // Fetch data on startup
  }
 
 Future<void> fetchMedicineData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not logged in.");
      return;
    }

    final userId = user.email;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medicines')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        medicineName = data['name'];
        doseAmount = data['dose'];
        doseUnit = data['unit'];
        reminderTime = data['time'];
      });
    } else {
      print("No medicine found for this user.");
    }
  } catch (e) {
    print("Error fetching medicine data: $e");
  }
}


  void _updateTime() {
    setState(() {
      _now = DateTime.now();
    });
  }

  // Future<void> fetchMedicineData() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('medicines')
  //         .limit(1)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       final data = snapshot.docs.first.data();
  //       setState(() {
  //         medicineName = data['name'];
  //         doseAmount = data['doseAmount'];
  //         doseUnit = data['doseUnit'];
  //         reminderTime = data['reminderTime'];
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching medicine data: $e");
  //   }
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime => DateFormat('hh:mm:ss a').format(_now);
  String get formattedDate => DateFormat('EEEE, MMMM d').format(_now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Medicine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 20),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              formattedTime,
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(Icons.medication,
                      size: 50, color: Color.fromARGB(255, 225, 4, 4)),
                  SizedBox(height: 10),
                  Text(
                    "Next Medicine in:",
                    style: TextStyle(
                        fontSize: 18, color: Colors.blueGrey[900]),
                  ),
                  SizedBox(height: 6),
                  Text(
                    reminderTime ?? "--:--",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    medicineName != null && doseAmount != null && doseUnit != null
                        ? "$medicineName - $doseAmount $doseUnit"
                        : "Loading...",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Weekly Schedule",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final today = _now.weekday;
                  final day = DateFormat.E().format(
                    _now.subtract(Duration(days: today - index - 1)),
                  );
                  final isToday = today == index + 1;
                  return Column(
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? Colors.white
                              : Color.fromARGB(221, 161, 161, 161),
                        ),
                      ),
                      SizedBox(height: 6),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: isToday
                            ? Colors.white
                            : Color.fromARGB(255, 152, 152, 152),
                      )
                    ],
                  );
                }),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
