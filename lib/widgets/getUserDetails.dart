import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/login_form.dart';

class getUserDetails extends StatefulWidget {
  final String memberType;
  final PageController pageController;

  const getUserDetails(
      {super.key, required this.memberType, required this.pageController});
  @override
  State<getUserDetails> createState() => _getUserDetailsState();
}

class _getUserDetailsState extends State<getUserDetails> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String? _name;
  String? _phone;
  String? _email;
  String? _password;

  Future<void> storeData() async {
    switch (widget.memberType) {
      case "gym_owner":
        CollectionReference collection = fireStore.collection('gym_owners');
        await collection.add({
          'type': widget.memberType,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'pass': _password,
        });
        break;
      case "trainer":
        CollectionReference collection = fireStore.collection('trainers');
        await collection.add({
          'type': widget.memberType,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'pass': _password,
        });
        break;
      case "member":
        CollectionReference collection = fireStore.collection('members');
        await collection.add({
          'type': widget.memberType,
          'name': _name,
          'phone': _phone,
          'email': _email,
          'pass': _password,
        });
        break;
      default:
        const Text("Collection not found :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getUserDetails(),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 132,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent),
                onPressed: () {
                  widget.pageController.previousPage(
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
                onPressed: () {
                  storeData();

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Account Created'),
                    duration: Duration(milliseconds: 100),
                  ));
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
    );
  }

  Widget getUserDetails() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
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
        ],
      ),
    );
  }
}
