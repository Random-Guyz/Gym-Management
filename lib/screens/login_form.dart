import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/screens/create_account.dart';

import 'home_screen.dart';
import 'new_create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form

  // Form fields data
  String _name = '';
  String _email = '';

  Future<void> _checkUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    // Query to find documents where "email" field matches entered email
    Query query =
        users.where('email', isEqualTo: _email).where('name', isEqualTo: _name);

    query.get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
            duration: Duration(seconds: 3), // Optional: Set snackbar duration
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text(
      //     "Login",
      //     style: TextStyle(
      //         color: Colors.green), // Set app bar title color to green
      //   ),
      //   centerTitle: true,
      // ),
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
                      cursorColor: Colors.lightGreenAccent,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
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
                        _name = value!;
                      },
                    ),
                    const SizedBox(height: 16),
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
                            // You can now use _name and _email variables
                            // for further processing, e.g., submitting to a server
                            // For now, just print the data
                            print('Name: $_name');
                            print('Email: $_email');
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
                                        const SignUpScreen()));
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
// New create account in development
//                   Delete from here

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Create_Account()));
                      },
                      child: const Text(
                        'New Create account',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white, // Set link color to green
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // to here!
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
