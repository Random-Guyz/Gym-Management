import 'package:flutter/material.dart';

import '../screens/login_form.dart';

class GetUserDetails extends StatefulWidget {
  final String memberType;
  final PageController pageController;

  const GetUserDetails(
      {Key? key, required this.memberType, required this.pageController})
      : super(key: key);
  @override
  State<GetUserDetails> createState() => _GetUserDetailsState();
}

class _GetUserDetailsState extends State<GetUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        returnInputFields(),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent),
                onPressed: () {
                  widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 900),
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
            SizedBox(
              width: 20,
            ),
            SizedBox(
              // width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent),
                onPressed: () {
                  widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 900),
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

  Widget returnInputFields() {
    switch (widget.memberType) {
      case "gym_owner":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("You're Gym Owner")],
        );
      case "trainer":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("You're a trainer")],
        );
      case "user":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("You're a user")],
        );

      default:
        return Text("Nothing Selected!");
    }
  }
}
