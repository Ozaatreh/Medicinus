import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineReminderPage extends StatefulWidget {
  @override
  _MedicineReminderPageState createState() => _MedicineReminderPageState();
}

class _MedicineReminderPageState extends State<MedicineReminderPage> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
    });
  }

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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 20),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
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
                  Icon(Icons.medication, size: 50, color: const Color.fromARGB(255, 225, 4, 4)),
                  SizedBox(height: 10),
                  Text(
                    "Next Medicine in:",
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "02:35:22",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Paracetamol - 500mg",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Weekly Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
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
                          color: isToday ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor:
                            isToday ? Colors.white : const Color.fromARGB(255, 152, 152, 152),
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
