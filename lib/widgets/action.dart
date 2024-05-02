import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyAction extends StatefulWidget {
  final String title;
  final Widget myIcon;
  final VoidCallback onPressed;
  const MyAction(
      {super.key,
      required this.title,
      required this.myIcon,
      required this.onPressed});

  @override
  State<MyAction> createState() => _MyActionState();
}

class _MyActionState extends State<MyAction> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade900,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User details
              Column(
                children: [
                  Text(widget.title),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  widget.onPressed();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove hover background
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Set text color
                  padding: MaterialStateProperty.all(const EdgeInsets.all(18.0)), // Adjust padding
                ),
                child: widget.myIcon,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
