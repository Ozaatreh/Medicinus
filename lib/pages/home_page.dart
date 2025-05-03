import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicinus/add_medicine.dart';


class HomePage extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blueGrey,
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('medicines')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No medicines added"));
          }

          var medicines = snapshot.data!.docs;

          return Column(
            children: [
               SizedBox(height: 90),
            Center(
              child: Text(
                'My Medicine',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    var medicine = medicines[index].data() as Map<String, dynamic>;
                
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      color: Color(0xFFE0E5EC),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.medication,
                          size: 40,
                          color: Colors.blueGrey,
                        ),
                        title: Text(
                          medicine['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Dose: ${medicine['dose']}"),
                        trailing: Text("Time: ${medicine['time']}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicinePage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white, // Adjust the color as needed
      ),
    );
  }
}
