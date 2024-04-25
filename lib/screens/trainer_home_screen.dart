import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/login_form.dart';


class TrainerHomeScreen extends StatefulWidget {
  final String emailId;
  final String pass;

  // const TrainerHomeScreen({super.key}); // Normal Constructor
  const TrainerHomeScreen(
      {super.key, required this.emailId, required this.pass});

  @override
  State<TrainerHomeScreen> createState() => _TrainerHomeScreenState();
}

class _TrainerHomeScreenState extends State<TrainerHomeScreen> {
  int myIndex = 0;

  late List<Widget> content = [
   const Text("Trainer Screen"),
  const Text("Demo Screen"),
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
