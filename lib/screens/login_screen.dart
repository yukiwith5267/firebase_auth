import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/button.dart';
import 'package:demo/widgets/textfield.dart';
import 'package:demo/widgets/square_tile.dart';
import 'package:demo/screens/home_screen.dart'; // HomeScreenのインポート

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

    // Add extension mark to empty fields
    if (emailController.text.isEmpty) {
      emailController.text = emailController.text + ' *';
    }
    if (passwordController.text.isEmpty) {
      passwordController.text = passwordController.text + ' *';
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
            errorMessage = 'ユーザーが見つかりません。';
            break;
          case 'wrong-password':
            errorMessage = 'パスワードが間違っています。';
            break;
          default:
            errorMessage = 'ユーザーが見つかりません。';
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
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
                      Text(
                        'パスワードをお忘れですか ?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // display error message
                Container(
                  height: 20, // 固定の高さを設定
                  child: errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(), // エラーメッセージがない場合は空のコンテナを表示
                ),

                const SizedBox(height: 10), // 余白を追加

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
                // google + apple sign in buttons

                const Column(
                  children: [
                    SquareTile(
                        imagePath: 'lib/images/google.png', text: 'Googleで続ける'),
                    SizedBox(height: 10),
                    SquareTile(
                        imagePath: 'lib/images/apple.png', text: 'Appleで続ける'),
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
