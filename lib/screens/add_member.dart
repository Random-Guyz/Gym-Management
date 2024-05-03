import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/show_message.dart';

class AddMember extends StatefulWidget {
  final String gymName;
  const AddMember({super.key, required this.gymName});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _formkey = GlobalKey<FormState>();

  String? _name;
  String? _phone;
  String? _email;
  String? _password;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> storeData() async {
    CollectionReference collection = firestore.collection("members");
    try {
      await collection.add({
        'type': 'member',
        'name': _name,
        'phone': _phone,
        'email': _email,
        'gym_name': widget.gymName,
        'pass': _password,
      });
    } catch (e) {
      showMessage("Member not added | Something Went Wrong");
    }
  }

  Future<void> _checkUsers() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference members = firestore.collection('members');

      Query membersQuery = members
          .where('email', isEqualTo: _email)
          .where('password', isEqualTo: _password);

      // Get documents matching the query
      QuerySnapshot querySnapshot = await membersQuery.get();

      // Check if any documents exist
      if (querySnapshot.docs.isNotEmpty) {
        showMessage("User Already Exists!");
      } else {
        await storeData();
        showMessage("Member Added");
      }
    } catch (e) {
      showMessage("Something went wrong with Firebase");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Add Member to your gym",
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
                  if (!RegExp(
                          r"^((\+)?([ \-.]?)?\(?0?91\)?[ \-.]?)?[789]\d{9}$")
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
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          try {
                            await _checkUsers();
                          } catch (e) {
                            showMessage("Something Went Wrong!");
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

              // const SizedBox(height: 16),

              // navigate back to login
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Already have an account? ",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const LoginScreen()));
              //       },
              //       child: const Text(
              //         'Login',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
