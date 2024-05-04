import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/exercise_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/show_message.dart';
import '../widgets/action.dart';
import 'login_form.dart';

class MemberHomeScreen extends StatefulWidget {
  final String? emailId;
  final String? pass;

  // const MemberHomeScreen({super.key}); // Normal Constructor
  const MemberHomeScreen(
      {super.key, required this.emailId, required this.pass});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  int myIndex = 0;
  late List<Widget> content = [
    const ExerciseScreen(),
    getUserDetails(),
  ];

  String _fetchedName = "";
  String _fetchedEmail = "";
  String _fetchedImage = "";
  // String _fetchedGym = "";

  bool _isLoading = false;
  String imageUrl = "";

  Future<void> storeData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference collection = fireStore.collection('members');

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
      CollectionReference members = firestore.collection('members');

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
            // _fetchedGym = data['gym_name'];
          }
        });
      } else {
        setState(() {
          _fetchedName = "User not found";
          _fetchedEmail = "Email not found";
          _fetchedImage = "Image not found";
          // _fetchedGym = "No Gym Found";
        });
      }
    } catch (e) {
      showMessage("Something went wrong with Firebase");
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
              icon: Icon(Icons.fitness_center), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Apps"),
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
                                  // Update _fetchedImage with the new URL
                                  setState(() {
                                    _fetchedImage = imageUrl;
                                  });
                                  await storeData();
                                } catch (e) {
                                  showMessage("Error Getting Image");
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey.shade900,
                                      backgroundImage:
                                          NetworkImage(_fetchedImage),
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
                    // Actions Buttons
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      child: MyAction(
                        title: "Mark Attendance",
                        myIcon: const Icon(
                          Icons.qr_code,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      child: MyAction(
                        title: "View Trainer",
                        myIcon: const Icon(
                          Icons.sports_mma,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      child: MyAction(
                        title: "Pay Fees",
                        myIcon: const Icon(
                          Icons.payments_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      child: MyAction(
                        title: "Log Out",
                        myIcon: const Icon(
                          Icons.logout,
                          size: 18,
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
          );
        }
      },
    );
  }
}
