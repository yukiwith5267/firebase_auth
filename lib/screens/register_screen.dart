// import 'package:demo/services/auth_services.dart';
import 'package:demo/widgets/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/button.dart';
import 'package:demo/widgets/textfield.dart';
// import 'package:demo/widgets/square_tile.dart';
import 'package:demo/screens/home_screen.dart'; // HomeScreenのインポート

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfigController =
      TextEditingController(); // Added for password configuration

  bool isLoading = false;
  String errorMessage = '';

  // sign user in method
  void signUserUp() async {
    // Add a showDialog while loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfigController.text.isEmpty) {
      // Check if password configuration is empty
      setState(() {
        errorMessage = 'Please fill in all fields';
        isLoading = false;
      });
      return;
    }

    if (passwordController.text != passwordConfigController.text) {
      // Check if passwords match
      setState(() {
        errorMessage = 'Passwords do not match';
        isLoading = false;
      });
      return;
    }

    try {
      // Show CircularProgressIndicator while waiting
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // サインインに成功した場合、HomeScreenに遷移
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided for that user.';
            break;
          default:
            errorMessage = e.message!;
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: emailController,
                hintText: 'メールアドレス',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'パスワード',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: passwordConfigController,
                hintText: 'パスワードの確認',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              Text(
                passwordController.text,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              // sign in button
              MyButton(
                buttonText: '続ける',
                onTap: isLoading ? null : signUserUp,
                child: isLoading ? CircularProgressIndicator() : Text('続ける'),
                textColor: Colors.white,
                backgroundColor: Colors.blue,
              ),

              const SizedBox(height: 30),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'または',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Column(
                children: [
                  SquareTile(
                    imagePath: 'lib/images/google.png',
                    text: 'Googleで続ける',
                  ),
                  SizedBox(height: 10),
                  SquareTile(
                    imagePath: 'lib/images/apple.png',
                    text: 'Appleで続ける',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
