import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineDetailsPage extends StatefulWidget {
  final String userId;
  final String medicineId;

  const MedicineDetailsPage({
    super.key,
    required this.userId,
    required this.medicineId,
  });

  @override
  State<MedicineDetailsPage> createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
  @override
  void initState() {
    super.initState();
    _markNotificationAsRead();
  }

  void _markNotificationAsRead() async {
    // Clear any pending notifications for this medicine
    await AwesomeNotifications().cancelAll();
  }
  
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchMedicine() {
  print('🟢 Fetching medicine for:');
  print('   User ID: ${widget.userId}');
  print('   Medicine ID: ${widget.medicineId}');
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
      .collection('medicines')  // Double check this spelling!
      .doc(widget.medicineId)
      .get()
      .then((doc) {
        print('🔵 Document exists? ${doc.exists}');
        if (doc.exists) {
          print('   Data: ${doc.data()}');
        }
        return doc;
      });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: fetchMedicine(),
        builder: (context, snapshot) { 
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.white);
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text(
                'Medicine not found',
                style: TextStyle(color: Colors.white),
              );
            }

            final data = snapshot.data!.data()!;
            final name = data['name'] ?? 'Unknown';
            final dose = data['dose'] ?? '';
            final doseUnit = data['unit'] ?? '';

            return Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      'MEDICATION REMINDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.medication_outlined,
                      size: 80,
                      color: Colors.redAccent[400],
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Time for your medication',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800]!.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blueGrey[600]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$dose $doseUnit',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'MARK AS TAKEN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    
  }
}
