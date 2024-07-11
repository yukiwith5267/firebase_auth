import 'package:demo/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/button.dart';
import 'package:demo/widgets/textfield.dart';
import 'package:demo/widgets/square_tile.dart';
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

  // sign user up method
  void signUserUp() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Check if any input field is empty
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfigController.text.isEmpty) {
      setState(() {
        errorMessage = 'すべてのフィールドを入力してください';
        isLoading = false;
      });
      return;
    }

    if (passwordController.text != passwordConfigController.text) {
      // Check if passwords match
      setState(() {
        errorMessage = 'パスワードが一致しません';
        isLoading = false;
      });
      return;
    }

    try {
      // Show CircularProgressIndicator while waiting
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Close the dialog and navigate to HomeScreen upon successful sign-up
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the dialog in case of an error
      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'このメールアドレスはすでに登録されています。';
        } else {
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
          child: SingleChildScrollView(
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

                const SizedBox(height: 30),

                // sign up button
                MyButton(
                  buttonText: '続ける',
                  onTap: isLoading ? null : signUserUp,
                  child: isLoading ? CircularProgressIndicator() : Text('続ける'),
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),

                const SizedBox(height: 10),

                // display error message
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        )
                      : Container(),
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
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Column(
                  children: [
                    SquareTile(
                      onTap: () async {
                        final user = await AuthServices().signInWithGoogle();
                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }
                      },
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
      ),
    );
  }
}
