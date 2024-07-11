import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap; // Added onTap option
  final String? text; // New optional text field

  const SquareTile({
    super.key,
    required this.imagePath,
    this.onTap,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            // Added Row to display image and text horizontally
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 25,
              ),
              const SizedBox(width: 20),
              if (text != null) // Display text if provided
                Text(text!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
