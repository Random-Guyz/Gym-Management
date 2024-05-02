import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/login_form.dart';
import 'package:gym_management_2/utils/show_message.dart';
import 'package:gym_management_2/widgets/action.dart';
import 'package:gym_management_2/widgets/box.dart';
import 'package:image_picker/image_picker.dart';

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

class Trainer {
  final String name;
  final String email;
  // Add other member properties as needed

  Trainer({required this.name, required this.email});

  // Add a factory constructor (optional) to create a Member from a Map

  factory Trainer.fromMap(Map<String, dynamic> data) => Trainer(
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
    getTrainersList()
  ];

  String _fetchedName = "";
  String _fetchedEmail = "";
  String _fetchedImage = "";

  bool _isLoading = false;
  String imageUrl = "";

  Future<void> storeData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference collection = fireStore.collection('gym_owners');

    QuerySnapshot snapshot =
        await collection.where("email", isEqualTo: _fetchedEmail).get();

    // Check if the document exists
    if (snapshot.docs.isNotEmpty) {
      // Update the existing document
      await snapshot.docs.first.reference.update({'image': imageUrl});
    } else {
      // Add a new document
      await collection.add({'email': _fetchedEmail, 'image': imageUrl});
    }
  }

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
            _fetchedEmail = data['email'];
            _fetchedImage = data['image'];
          }
        });
      } else {
        setState(() {
          _fetchedName = "User not found";
          _fetchedEmail = "Email not found";
          _fetchedImage = "Image Not Found";
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

      final gymOwnerDoc = await firestore
          .collection('gym_owners')
          .where('email', isEqualTo: widget.emailId)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

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

  Future<List<Trainer>> _fetchTrainers() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final gymOwnerDoc = await firestore
          .collection('gym_owners')
          .where('email', isEqualTo: widget.emailId)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      // Extract the gym name from the gym owner document
      final gymName = gymOwnerDoc.get('gym_name');

      if (gymName == null) {
        // Handle case where gym name is missing in gym owner document
        return [];
      }

      // Stream or Future-based query to fetch members with matching gym name
      final trainersStream = firestore
          .collection('trainers')
          .where('gym_name', isEqualTo: gymName)
          .snapshots(); // For real-time updates

      // Convert stream to a list if needed (for one-time fetching)
      final trainerList = await trainersStream.first.then((snapshot) =>
          snapshot.docs.map((doc) => Trainer.fromMap(doc.data())).toList());

      return trainerList;
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
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Members"),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_mma), label: "Trainers"),
        ],
      ),
      body: Center(child: content[myIndex]),
    );
  }

  Widget getUserDetails() {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: Column(
                  children: [
                    Container(
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
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Request storage permission for gallery access
                                ImagePicker picker = ImagePicker();
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.gallery);

                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();

                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDirImages =
                                    referenceRoot.child('images');

                                Reference referenceImageToUpload =
                                    referenceDirImages.child(uniqueFileName);

                                // store the file
                                try {
                                  await referenceImageToUpload
                                      .putFile(File(file!.path));
                                  imageUrl = await referenceImageToUpload
                                      .getDownloadURL();
                                  await storeData();
                                } catch (e) {
                                  showMessage("Error Getting Image");
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                setState(() {
                                  _isLoading = false;
                                }
                                );
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey.shade900,
                                      backgroundImage: NetworkImage(imageUrl),
                                      radius: 35,
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _fetchedName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _fetchedEmail,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // ... rest of your widgets inside the Column
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget displayDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          getUserDetails(),
          FutureBuilder<List<Member>>(
            future: _fetchMembers(),
            builder: (context, AsyncSnapshot<List<Member>> memberSnapshot) {
              if (memberSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                );
              } else if (memberSnapshot.hasError) {
                return Text('Error: ${memberSnapshot.error}');
              } else {
                final memberCount = memberSnapshot.data?.length ?? 0;

                return FutureBuilder<List<Trainer>>(
                  // Use FutureBuilder<int> for trainer count
                  future: _fetchTrainers(), // Replace with your implementation
                  builder:
                      (context, AsyncSnapshot<List<Trainer>> trainerSnapshot) {
                    if (trainerSnapshot.hasError) {
                      return Text('Error: ${trainerSnapshot.error}');
                    } else {
                      final trainerCount = trainerSnapshot.data?.length ?? 0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: DashboardBox(
                                      count: memberCount, title: "Members"),
                                ),
                                Expanded(
                                  child: DashboardBox(
                                      count: trainerCount, title: "Trainers"),
                                ), // Update title and count
                              ],
                            ),
                          ),
                          // ... other widgets for your dashboard
                        ],
                      );
                    }
                  },
                );
              }
            },
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 32.0),
                  child: MyAction(
                    title: "Take Attendance",
                    myIcon: const Icon(
                      Icons.flip,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showMessage("Attendance");
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 32.0),
                  child: MyAction(
                    title: "Add Member",
                    myIcon: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showMessage("Member Added");
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 32.0),
                  child: MyAction(
                      title: "Add Trainer",
                      myIcon: const Icon(
                        Icons.sports_mma,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showMessage("Trainer Added");
                      }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 32.0),
                  child: MyAction(
                    title: "Log Out",
                    myIcon: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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

  Widget getTrainersList() {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trainers'), // Set the app bar title
        ),
        body: FutureBuilder(
          future: _fetchTrainers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Trainer>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final trainers = snapshot.data ?? [];
              if (trainers.isEmpty) {
                return const Center(child: Text('No Trainers in your gym'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var trainerData = snapshot.data?[index];
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
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage("assets/default.png"),
                                radius: 23,
                              ),
                              const SizedBox(width: 30),
                              // User details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(trainerData?.name ?? "Name"),
                                  Text(trainerData?.email ?? "Email"),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered)) {
                                              return Colors
                                                  .transparent; // Return transparent color for hovered state
                                            }
                                            return Colors.green
                                                .shade200; // Use default overlay color for other states
                                          },
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.info,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(
                                    width: 1,
                                  ),
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
        ));
  }

  Widget getMembersList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'), // Set the app bar title
      ),
      body: FutureBuilder(
        future: _fetchMembers(),
        builder: (BuildContext context, AsyncSnapshot<List<Member>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final members = snapshot.data ?? [];
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
                            const CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage("assets/default.png"),
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
                            // const Spacer(),
                            // Row(
                            //   children: [
                            //     TextButton(
                            //         onPressed: () {},
                            //         style: ButtonStyle(
                            //           overlayColor: MaterialStateProperty
                            //               .resolveWith<Color>(
                            //             (Set<MaterialState> states) {
                            //               if (states.contains(
                            //                   MaterialState.hovered)) {
                            //                 return Colors
                            //                     .transparent; // Return transparent color for hovered state
                            //               }
                            //               return Colors.green
                            //                   .shade200; // Use default overlay color for other states
                            //             },
                            //           ),
                            //         ),
                            //         child: const Icon(
                            //           Icons.info,
                            //           size: 20,
                            //           color: Colors.white,
                            //         )
                            //     ),
                            //     const SizedBox(
                            //       width: 1,
                            //     ),
                            //   ],
                            // )
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
      ),
    );
  }
}
