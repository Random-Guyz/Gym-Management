import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/login_form.dart';

class Member {
  final String name;
  final String email;
  // Add other member properties as needed

  Member({required this.name, required this.email});

  // Add a factory constructor (optional) to create a Member from a Map

  factory Member.fromMap(Map<String, dynamic> data) => Member(
        name: data['name'],
        email: data['email'],
      );
}

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
  late List<Widget> content = [
    displayDashboard(),
    getMembersList(),
    getTrainers()
  ];

  String _fetchedName = "";

  Future<void> _fetchUser() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Collection references for each collection
      CollectionReference members = firestore.collection('gym_owners');

      final querySnapshot = await members
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong with Firebase'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<Member>> _fetchMembers() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the gym owner's document based on the email
      final gymOwnerDoc = await firestore
          .collection('gym_owners')
          .where('email', isEqualTo: widget.emailId)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if (gymOwnerDoc == null) {
        // Handle case where gym owner document is not found
        return [];
      }

      // Extract the gym name from the gym owner document
      final gymName = gymOwnerDoc.get('gym_name');

      if (gymName == null) {
        // Handle case where gym name is missing in gym owner document
        return [];
      }

      // Stream or Future-based query to fetch members with matching gym name
      final membersStream = firestore
          .collection('members')
          .where('gym_name', isEqualTo: gymName)
          .snapshots(); // For real-time updates

      // Convert stream to a list if needed (for one-time fetching)
      final memberList = await membersStream.first.then((snapshot) =>
          snapshot.docs.map((doc) => Member.fromMap(doc.data())).toList());

      return memberList;
    } catch (e) {
      print(e); // Log the error for debugging
      return [];
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

  Widget displayMembers() {
    return FutureBuilder(
      future: checkMembersExist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool membersExist = snapshot.data as bool;
          if (!membersExist) {
            return const Center(child: Text('No users'));
          } else {
            return getMembersList();
          }
        }
      },
    );
  }

  Future<bool> checkMembersExist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('members').get();
    return querySnapshot.docs.isNotEmpty;
  }

  Widget getMembersList() {
    return FutureBuilder(
      future: _fetchMembers(), // Call _fetchMembers to retrieve members
      builder: (BuildContext context, AsyncSnapshot<List<Member>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final members = snapshot.data ?? []; // Handle potential null value
          if (members.isEmpty) {
            return const Center(child: Text('No members in your gym'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var memberData = snapshot.data?[index];
                // Outside padding
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // User Image
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                                'https://picsum.photos/250?image=9'),
                          ),
                          const SizedBox(width: 30),
                          // User details
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(memberData?.name ?? "Name"),
                              Text(memberData?.email ?? "Email"),
                            ],
                          ),
                          const Spacer(),
                          // Action Buttons
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors
                                              .transparent; // Return transparent color for hovered state
                                        }
                                        return Colors.green
                                            .shade200; // Use default overlay color for other states
                                      },
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 1,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors
                                              .transparent; // Return transparent color for hovered state
                                        }
                                        return Colors.grey
                                            .shade900; // Use default overlay color for other states
                                      },
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  // Widget getMembersList() {
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection('members').snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (!snapshot.hasData) {
  //         return const CircularProgressIndicator();
  //       }
  //       return ListView.builder(
  //         itemCount: snapshot.data!.docs.length,
  //         itemBuilder: (context, index) {
  //           var memberData =
  //               snapshot.data!.docs[index].data() as Map<String, dynamic>;
  //           // Outside padding
  //           return Padding(
  //             padding: const EdgeInsets.all(18.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(color: Colors.grey.shade900),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(20),
  //                 child: Row(
  //                   children: [
  //                     // User Image
  //                     CircleAvatar(
  //                       radius: 23,
  //                       backgroundImage: NetworkImage(memberData['avatarUrl'] ??
  //                           'https://picsum.photos/250?image=9'),
  //                     ),
  //                     const SizedBox(width: 30),
  //                     // User details
  //                     const Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         // Text(memberData['username'] ?? ''),
  //                         // Text(memberData['detail'] ?? ''),
  //                         Text('Username'),
  //                         Text('detail'),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     // Action Buttons
  //                     Row(
  //                       children: [
  //                         TextButton(
  //                             onPressed: () {},
  //                             style: ButtonStyle(
  //                               overlayColor:
  //                                   MaterialStateProperty.resolveWith<Color>(
  //                                 (Set<MaterialState> states) {
  //                                   if (states
  //                                       .contains(MaterialState.hovered)) {
  //                                     return Colors
  //                                         .transparent; // Return transparent color for hovered state
  //                                   }
  //                                   return Colors.green
  //                                       .shade200; // Use default overlay color for other states
  //                                 },
  //                               ),
  //                             ),
  //                             child: const Icon(
  //                               Icons.edit,
  //                               size: 20,
  //                               color: Colors.white,
  //                             )),
  //                         const SizedBox(
  //                           width: 2,
  //                         ),
  //                         TextButton(
  //                             onPressed: () {},
  //                             style: ButtonStyle(
  //                               overlayColor:
  //                                   MaterialStateProperty.resolveWith<Color>(
  //                                 (Set<MaterialState> states) {
  //                                   if (states
  //                                       .contains(MaterialState.hovered)) {
  //                                     return Colors
  //                                         .transparent; // Return transparent color for hovered state
  //                                   }
  //                                   return Colors.grey
  //                                       .shade900; // Use default overlay color for other states
  //                                 },
  //                               ),
  //                             ),
  //                             child: const Icon(
  //                               Icons.delete,
  //                               size: 20,
  //                               color: Colors.white,
  //                             )),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
