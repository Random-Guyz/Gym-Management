import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/login_form.dart';

class OwnerHomeScreen extends StatefulWidget {
  final String? emailId;
  final String? pass;

  // const OwnerHomeScreen({super.key}); // Normal Constructor
  const OwnerHomeScreen({super.key, required this.emailId, required this.pass});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  int myIndex = 0;
  late List<Widget> content = [displayDashboard(), getMembers(), getTrainers()];
  String _fetchedName = "";

  Future<void> _fetchUser() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Collection references for each collection
      CollectionReference gymOwners = firestore.collection('gym_owners');

      final querySnapshot = await gymOwners
          .where('email', isEqualTo: widget.emailId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          if (data is Map) {
            _fetchedName = data['name'];
          }
        });
      } else {
        setState(() {
          _fetchedName = "User not found";
        });
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Something went wrong with Firebase'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    }
  }

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
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Members"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_mma), label: "Trainers"),
        ],
      ),
      body: Center(child: content[myIndex]),
    );
  }

  Widget displayDashboard() {
    return FutureBuilder(
      future: _fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
          ); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, right: 20, bottom: 15, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.lightGreenAccent,
                          radius: 35,
                        ),
                        Text(
                          _fetchedName,
                        ) // Show a default text if _fetchedName is null
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget getMembers() {
    return const Column(
      children: [],
    );
  }

  Widget getTrainers() {
    return Column(
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
    );
  }
}
