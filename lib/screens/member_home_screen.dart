import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/login_form.dart';

class MemberHomeScreen extends StatefulWidget {
  final String? emailId;
  final String? pass;

  // const MemberHomeScreen({super.key}); // Normal Constructor
  const MemberHomeScreen({super.key, required this.emailId, required this.pass});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  int myIndex = 0;
  late List<Widget> content = [
    const Text("Member Page"),
    const Text("Demo Page"),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Profile Screen"),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text(
              "Log out",
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 13,
                  fontWeight: FontWeight.w900),
            ))
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedIconTheme: const IconThemeData(
          color: Colors.lightGreenAccent,
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 30,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Apps"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Center(child: content[myIndex]),
    );
  }
}
