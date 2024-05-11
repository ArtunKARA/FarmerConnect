import 'dart:convert';
import 'dart:io';
import 'package:farmerconnect/farmmer/mainScreenFarmer.dart';
import 'package:farmerconnect/supplier/mainScreenSupplier.dart';
import 'package:farmerconnect/veterinarian/mainScreenVeterinarian.dart';
import 'package:http/http.dart' as http;
import 'package:farmerconnect/model/userType.dart';
import 'package:farmerconnect/signin.dart';
import 'package:farmerconnect/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_auth_implementation/firebase_auth_services.dart';
import 'global/toast.dart';

import 'home.dart';
import 'model/userType.dart';

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
                    color: Colors.green,
                  ),
                  child: Center(
                      child: _isSigningUp ? CircularProgressIndicator(color: Colors.green,): Text(
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
                          color: Colors.green, fontWeight: FontWeight.bold),
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

    // Asenkron olarak userType verisini al
    Future<List<userType>> userTypesFuture = getPostUser(email);

    // userType verisini al, sonra yönlendirme yap
    userTypesFuture.then((userTypes) {
      setState(() {
        _isSigningUp = false;
      });

      if (user != null) {
        showToast(message: "User is successfully logged in");
        if(userTypes.isNotEmpty){
          String userType = userTypes[0].userTypes;
          if(userType == "f"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => mainScreenFarmer()),
            );
          } else if(userType == "s"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => mainScreenSupplier()),
            );
          } else if(userType == "v"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => mainScreenVeterinarian()),
            );
          } else {
            showToast(message: "User type is not recognized");
          }
        } else {
          showToast(message: "User type is not found");
        }
      } else {
        showToast(message: "Some error happened");
      }
    }).catchError((error){
      setState(() {
        _isSigningUp = false;
      });
      showToast(message: error.toString());
    });
  }


  Future<List<userType>> getPostUser(mail) async {
    try {
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/user/type/"+ mail));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return userType(
              userTypes: map["userType"]);
        }).toList();
      }
    } on SocketException {
      throw Exception("Network Connectivity Error");
    }
    throw Exception("Fetch Data Error");
  }
}