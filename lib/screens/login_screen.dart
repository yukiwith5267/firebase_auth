import 'package:demo/screens/forgot_pw_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/button.dart';
import 'package:demo/widgets/textfield.dart';
import 'package:demo/widgets/square_tile.dart';
import 'package:demo/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  // sign user in method
  void signUserIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'メールアドレスとパスワードを入力してください';
        isLoading = false;
      });
      return;
    }

    // Add validation for email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      setState(() {
        errorMessage = '正しいメールアドレスの形式を入力してください。';
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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Close the dialog and navigate to HomeScreen upon successful sign-in
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the dialog in case of an error
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'メールアドレスが無効です。';
            break;
          case 'user-disabled':
            errorMessage = 'このユーザーは無効化されています。';
            break;
          case 'user-not-found':
            errorMessage = 'そのメールアドレスで登録されたユーザーが見つかりません。';
            break;
          case 'wrong-password':
            errorMessage = 'パスワードが正しくありません。';
            break;
          default:
            errorMessage = '登録されたユーザーが見つかりません。または、パスワード、メールアドレスのいずれかが間違っています。';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // username textfield
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

                const SizedBox(height: 20),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPwScreen()),
                          );
                        },
                        child: Text(
                          'パスワードをお忘れですか ?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

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

                const SizedBox(height: 10),

                // sign in button
                MyButton(
                  buttonText: 'ログイン',
                  onTap: isLoading ? null : signUserIn,
                  child: isLoading ? CircularProgressIndicator() : Text('ログイン'),
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),

                const SizedBox(height: 50),

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
      ),
    );
  }
}
