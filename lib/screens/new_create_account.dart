import 'package:flutter/material.dart';

import '../widgets/getUserDetails.dart';
import 'login_form.dart';

class Create_Account extends StatefulWidget {
  const Create_Account({super.key});

  @override
  State<Create_Account> createState() => _Create_AccountState();
}

class _Create_AccountState extends State<Create_Account> {
  final _formkey = GlobalKey<FormState>();
  final pageController = PageController(
    initialPage: 0,
  );
  List<DropdownMenuItem<String>> memberType = [
    const DropdownMenuItem(value: 'gym_owner', child: Text("Gym Owner")),
    const DropdownMenuItem(value: 'trainer', child: Text("Trainer")),
    const DropdownMenuItem(value: 'user', child: Text("User")),
  ];

  static String? dropdownvalue;

  // final String _accountType = '';
  // final String _name = '';
  // final String _email = '';
  // final String _password = '';
  // final String _gymname = "";
  // final String _phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("New Create Account Page"),
      // ),
      body: Form(
        key: _formkey,
        child: PageView(
          controller: pageController,
          children: [
            Container(
              child: accountType(),
            ),
            Container(
              child: GetUserDetails(memberType: dropdownvalue.toString(), pageController: pageController),
            ),
            Container(
              color: Colors.amberAccent,
              child: const Center(child: Text("Third")),
            ),
          ],
        ),
      ),
    );
  }

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

              const SizedBox(height: 31),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  onPressed: () {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.decelerate);
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
        )
      ],
    );
  }
}
