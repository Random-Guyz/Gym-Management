import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/login_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form

  // Form fields data
  String _name = '';
  String _email = '';
  String _password = '';
  // String _confirmPassword = '';

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Access Firestore instance
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Create a new user collection (or use an existing one)
        CollectionReference users = firestore.collection('users');
        // Create a Map to store user data
        Map<String, dynamic> userData = {
          'name': _name,
          'email': _email,
          // Password should not be stored directly in Firestore due to security concerns. Consider using a secure authentication method like Firebase Authentication.
          'password': _password,
        };
        // Add user data to the collection
        await users.add(userData);

        // Show success message or perform other actions
        print('User created successfully!');
      } catch (e) {
        // Handle any errors that occur during the Firestore operation
        print('Error creating user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text(
        //     "Signup Page",
        //     style: TextStyle(color: Colors.green),
        //   ),
        //   centerTitle: true,
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Let's create your account!",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
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
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          cursorColor: Colors.lightGreenAccent,
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
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!.trim();
                          },
                        ),
                        const SizedBox(height: 16),

                        const SizedBox(height: 15),
                        // signup button logic
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreenAccent),
                            onPressed: () async {
                              await _saveForm();
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
