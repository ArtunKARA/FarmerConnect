import 'package:farmerconnect/signin.dart';
import 'package:farmerconnect/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_auth_implementation/firebase_auth_services.dart';
import 'global/toast.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Yap"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Giriş Yap",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "E-Posta",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Şifre",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _signIn,

                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration:
                      BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF2ECC71),
                      ),
                  child: Center(
                      child: _isSigningUp ? CircularProgressIndicator(color: Color(0xFF2ECC71),): Text(
                    "Giriş Yap",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),

              SizedBox(height: 10,),

              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabınız Yok Mu?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                          color: Color(0xFF2ECC71), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {

    setState(() {
      _isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "Giriş Başarılı");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Bir Hata Oluştu");
    }
  }
}
