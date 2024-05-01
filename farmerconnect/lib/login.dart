import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: ()async{
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool("Giriş Ekranı", false);
          },
          child: const Text("Giriş Ekranı"),
        ),
      ),
    );
  }
}