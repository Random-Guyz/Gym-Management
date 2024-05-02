import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/show_message.dart';
import 'login_form.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formkey = GlobalKey<FormState>();
  final pageController = PageController(
    initialPage: 0,
  );
  List<DropdownMenuItem<String>> memberType = [
    const DropdownMenuItem(value: 'gym_owner', child: Text("Gym Owner")),
    const DropdownMenuItem(value: 'trainer', child: Text("Trainer")),
    const DropdownMenuItem(value: 'member', child: Text("Member")),
  ];

  static String? dropdownvalue;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String? _name;
  String? _phone;
  String? _email;
  String? _gymName;
  String? _password;

  Future<void> storeData() async {
    switch (dropdownvalue) {
      case "gym_owner":
        CollectionReference collection = fireStore.collection('gym_owners');
        await collection.add({
          'type': dropdownvalue,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'gym_name': _gymName,
          'pass': _password,
        });
        break;
      case "trainer":
        CollectionReference collection = fireStore.collection('trainers');
        await collection.add({
          'type': dropdownvalue,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'gym_name': _gymName,
          'pass': _password,
        });
        break;
      case "member":
        CollectionReference collection = fireStore.collection('members');
        await collection.add({
          'type': dropdownvalue,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'gym_name': _gymName,
          'pass': _password,
        });
        break;
      default:
        const Text("Collection not found :(");
    }
  }

  Future<void> _checkUsers() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Collection references for each collection
      CollectionReference gymOwners = firestore.collection('gym_owners');
      CollectionReference trainers = firestore.collection('trainers');
      CollectionReference members = firestore.collection('members');

      // Query to find documents where "email" field matches entered email
      Query gymOwnersQuery = gymOwners
          .where('email', isEqualTo: _email)
          .where('pass', isEqualTo: _password);
      Query trainersQuery = trainers
          .where('email', isEqualTo: _email)
          .where('pass', isEqualTo: _password);
      Query membersQuery = members
          .where('email', isEqualTo: _email)
          .where('pass', isEqualTo: _password);

      // Combine queries into a single list
      List<Query> queries = [gymOwnersQuery, trainersQuery, membersQuery];

      // Use Future.wait to execute all queries concurrently
      List<QuerySnapshot> querySnapshots =
          await Future.wait(queries.map((query) => query.get()));

      // Check if any query returned a non-empty result
      if (querySnapshots.any((snapshot) => snapshot.docs.isNotEmpty)) {
        showMessage(context, "User Already Exists!");
      } else {
        await storeData();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account Created'),
          duration: Duration(seconds: 1),
        ));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      showMessage(context, "Something went wrong with Firebase");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formkey,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: accountType(),
            ),
            getUserDetails(),
          ],
        ),
      ),
    );
  }

  // get the account type of the user
  Widget accountType() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text(
                "Let's create your account!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),

              DropdownButtonFormField(
                value: dropdownvalue,
                items: memberType,
                onChanged: (String? value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[900],
                  hintText: 'Select Account Type',
                  hintStyle: TextStyle(color: Colors.grey[950]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
                dropdownColor: Colors.grey[900],
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  onPressed: () {
                    if (dropdownvalue!.isNotEmpty) {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.decelerate);
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // navigate back to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close dialog first
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  // Displaying input fields
  Widget getUserDetails() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Let's get your details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            cursorColor: Colors.lightGreenAccent,
            decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(
                  Icons.person,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _name = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            cursorColor: Colors.lightGreenAccent,
            decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(
                  Icons.mail,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _email = value!;
              });
            },
          ),

          const SizedBox(height: 16),
          TextFormField(
            cursorColor: Colors.lightGreenAccent,
            decoration: InputDecoration(
                hintText: 'Gym',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(
                  Icons.fitness_center,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter gym name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _gymName = value!;
              });
            },
          ),

          const SizedBox(height: 16),
          TextFormField(
            cursorColor: Colors.lightGreenAccent,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: 'Phone',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(
                  Icons.phone,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone';
              }
              if (!RegExp(r"^((\+)?([ \-.]?)?\(?0?91\)?[ \-.]?)?[789]\d{9}$")
                  .hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _phone = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            cursorColor: Colors.lightGreenAccent,
            decoration: InputDecoration(
                hintText: 'Create Password',
                hintStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[900],
                prefixIcon: const Icon(
                  Icons.key,
                )),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            onSaved: (String? value) {
              setState(() {
                _password = value!;
              });
            },
          ),

          const SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 132,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  onPressed: () {
                    pageController.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.decelerate);
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 132,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      try {
                        await _checkUsers();
                      } catch (e) {
                        // Fluttertoast.showToast(
                        //     msg: "Something Went Wrong!",
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.CENTER,
                        //     timeInSecForIosWeb: 1,
                        //     backgroundColor: Colors.red,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0
                        // );
                        showMessage(context, "Something Went Wrong!");
                      }
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // navigate back to login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
