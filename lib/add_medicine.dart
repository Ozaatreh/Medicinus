import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Method to save medicine to Firestore
  void saveMedicine() async {
    if (nameController.text.isNotEmpty && doseController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medicines')
          .add({
        'name': nameController.text,
        'dose': doseController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context); // Navigate back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Medicine"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Medicine Name Input Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Medicine Name',
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
            ),
            SizedBox(height: 16),
            
            // Dose Input Field
            TextField(
              controller: doseController,
              decoration: InputDecoration(
                  hintText: 'Dose',
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
            ),
            SizedBox(height: 24),

            // Save Medicine Button
            ElevatedButton(
              onPressed: saveMedicine,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Save Medicine",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
