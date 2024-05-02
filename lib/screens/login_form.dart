import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/create_account.dart';
import 'package:gym_management_2/screens/member_home_screen.dart';
import 'package:gym_management_2/screens/owner_home_screen.dart';
import 'package:gym_management_2/screens/trainer_home_screen.dart';

import '../utils/show_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form

  // Form fields data
  String? _password;
  String? _email;

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
        showMessage("Login Successful!");

        // Determine the account type based on the index of the non-empty query
        int accountTypeIndex =
            querySnapshots.indexWhere((snapshot) => snapshot.docs.isNotEmpty);

        // Navigate to the appropriate home screen based on the account type
        switch (accountTypeIndex) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OwnerHomeScreen(emailId: _email, pass: _password),
              ),
            );
            break;
          case 1:
            // Navigate to trainer home screen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TrainerHomeScreen(emailId: _email!, pass: _password!)));
            break;
          case 2:
            // Navigate to member home screen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MemberHomeScreen(emailId: _email, pass: _password)));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unknown account type'),
                duration: Duration(seconds: 2),
              ),
            );
            break;
        }
      } else {
        showMessage("User not found");
      }
    } catch (e) {
      showMessage("Something went wrong with Firebase");
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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey, // Assigning the form key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hey, there!",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    TextFormField(
                      // Set text color to green
                      cursorColor: Colors.lightGreenAccent,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey[900],
                          prefixIcon: const Icon(Icons.mail)),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Basic email format validation
                        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: Colors.lightGreenAccent,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey[900],
                          prefixIcon: const Icon(
                            Icons.key,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16), // Add some space between fields
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreenAccent),
                        onPressed: () {
                          // Validate form
                          if (_formKey.currentState!.validate()) {
                            // Save form data
                            _formKey.currentState!.save();
                            // You can now use _password and _email variables
                            // for further processing, e.g., submitting to a server
                            // For now, just print the data
                            // print('pass: $_password');
                            // print('Email: $_email');
                            _checkUsers();
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            16), // Add some space between button and text field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              color: Colors.white), // Set text color to green
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccount()));
                          },
                          child: const Text(
                            'Create account',
                            style: TextStyle(
                              color: Colors.white, // Set link color to green
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
