import 'package:flutter/material.dart';
import 'package:medicinus/pages/home_page.dart';
import 'package:medicinus/pages/medicin_reminder.dart';


class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
 
  int selectedIndex = 1;
  

  // List of pages to display based on selected index
  final List<Widget> pages = [
    MedicineReminderPage(),
    HomePage(),
    HomePage(),
  ];

  // pages changer
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
    onWillPop: () async {
      // Handle custom back navigation logic here if needed
      // Returning `true` will allow the back action
      return false;
    },
      child: Scaffold(
          
          body: pages[selectedIndex],
      
          bottomNavigationBar: 
          BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              backgroundColor: const Color.fromARGB(255, 82, 106, 119),
              selectedItemColor: const Color.fromARGB(255, 239, 240, 241),
              unselectedItemColor: const Color.fromARGB(255, 233, 233, 233),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: "Schedule",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: "Notifications",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: "Timing",
                ),
              ],
            ),
      
      ),
    );
  }
}