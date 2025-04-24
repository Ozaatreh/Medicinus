import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  
  // Register User
  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String birthdate,
    required String phoneNumber,
  }) async {
    try {
      // Create User in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user details in Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'birthdate': birthdate,
        'phone_number': phoneNumber,
        'created_at': DateTime.now(),
      });

      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Login User
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
  }
}
