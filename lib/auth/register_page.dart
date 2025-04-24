import 'package:flutter/material.dart';
import 'package:medicinus/auth/auth_servises.dart';
import 'package:medicinus/pages/home_page.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final AuthService authService = AuthService();
  String? errorMessage;

  // Function to show the date picker and update the controller with the selected date
  void selectBirthdate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2012),
    );

    if (selectedDate != null) {
      setState(() {
        // Format the selected date to a readable format
        birthdateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

 void registerUser() async {
  String? error = await authService.registerUser(
    username: usernameController.text,
    email: emailController.text,
    password: passwordController.text,
    birthdate: birthdateController.text,
    phoneNumber: phoneNumberController.text,
  );

  if (error == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Navigate to home
    );
  } else {
    setState(() => errorMessage = error);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                  border: Border.all(color: const Color.fromARGB(255, 216, 215, 215), width: 1), // Adjust border color and width
                ),
                child: Image.asset(
                  'assets/Medicina2.png',
                  fit: BoxFit.fill, // Optional, depending on how you want the image to fit
                ),
              ),
              SizedBox(height: 60),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
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
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
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
              GestureDetector(
                onTap: () => selectBirthdate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthdateController,
                    decoration: InputDecoration(
                      hintText: "Birthdate",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: registerUser,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
