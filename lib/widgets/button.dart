import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText; // Added optional field for button text
  final Color? textColor; // Added optional field for text color
  final Color? backgroundColor; // Added optional field for background color

  const MyButton(
      {super.key,
      required this.onTap,
      required Widget child,
      required this.buttonText,
      required this.textColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color:
              backgroundColor, // Using the backgroundColor field if provided, elsebbb    default to black
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color:
                  textColor, // Using the textColor field if provided, else default to white
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
