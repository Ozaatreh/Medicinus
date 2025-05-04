import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicinePage extends StatefulWidget {
  final Map<String, dynamic>? medicineData;
  final String? medicineId;

  AddMedicinePage({this.medicineData, this.medicineId});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
    final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _type;
  String? _unit;
  final String? userId = FirebaseAuth.instance.currentUser!.email;
  String _selectedType = 'Capsule';
  String _selectedUnit = 'pill';
  TimeOfDay? _selectedTime;
  
  @override
  void initState() {
    super.initState();
    if (widget.medicineData != null) {
      _nameController.text = widget.medicineData!['name'];
      _doseController.text = widget.medicineData!['dose'].toString();
      _timeController.text = widget.medicineData!['time'];
      _type = widget.medicineData!['type'];
      _unit = widget.medicineData!['unit'];
    }
  }

  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

 void _saveMedicine() async {
  if (_nameController.text.isEmpty || _doseController.text.isEmpty || _selectedTime == null) return;

  final timeString = '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

  final data = {
    'name': _nameController.text,
    'type': _selectedType,
    'dose': _doseController.text,
    'unit': _selectedUnit,
    'time': timeString, // store in HH:mm format
  };

  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final medCollection = userDoc.collection('medicines');

  if (widget.medicineId != null) {
    // Edit mode
    await medCollection.doc(widget.medicineId).update(data);
  } else {
    // Add mode
    await medCollection.add(data);
  }

  // Convert TimeOfDay to DateTime
  DateTime now = DateTime.now();
  DateTime reminderTime = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);

  // Schedule the notification
  await scheduleMedicineNotification(reminderTime);

  Navigator.pop(context);
}


  // To schedule the notification
  Future<void> scheduleMedicineNotification(DateTime reminderTime) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'Medicine Reminder',
        body: 'It\'s time to take your medicine!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: reminderTime.year,
        month: reminderTime.month,
        day: reminderTime.day,
        hour: reminderTime.hour,
        minute: reminderTime.minute,
        second: reminderTime.second,
        millisecond: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Add Medication',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Medicine Name Field
              Text(
                'Medicine Name',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintText: 'Enter medicine name',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Medicine Type Dropdown
              Text(
                'Medicine Type',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedType,
                    dropdownColor: Colors.blueGrey[800],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    items: ['Capsule', 'Syrup', 'Tablet', 'Injection']
                      .map((e) => DropdownMenuItem(
                        value: e, 
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(e),
                        ),
                      ))
                      .toList(),
                    onChanged: (val) => setState(() => _selectedType = val!),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Dose Input
              Text(
                'Dosage',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _doseController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          hintText: 'Dose amount',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedUnit,
                          dropdownColor: Colors.blueGrey[800],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          items: ['pill','mg', 'ml']
                            .map((e) => DropdownMenuItem(
                              value: e, 
                              child: Text(e),
                            ))
                            .toList(),
                          onChanged: (val) => setState(() => _selectedUnit = val!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Time Picker Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedTime == null
                        ? "Set Reminder Time"
                        : "Reminder at ${_selectedTime!.format(context)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 249, 249, 249),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Save Medication",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
