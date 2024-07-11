import 'package:demo/screens/login_screen.dart';
import 'package:demo/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/button.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Text(
                  'Welcome to my app!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    buttonText: '無料で登録',
                    textColor: Colors.blue[500],
                    backgroundColor: Colors.white,
                    child: const Text('無料で登録'),
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    buttonText: 'ログイン',
                    textColor: Colors.white,
                    backgroundColor: Colors.blue[500],
                    child: const Text('ログイン'),
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
