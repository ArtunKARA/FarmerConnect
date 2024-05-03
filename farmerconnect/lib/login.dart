import 'package:flutter/material.dart';
import 'package:farmerconnect/signin.dart';

class login extends StatelessWidget {
  const login({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff2ECC71),
                Color(0xff281537),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                '\nFarmerConnect',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'E-Posta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF27AE60),
                            ),
                          )),
                    ),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Şifre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF27AE60),
                            ),
                          )),
                    ),
                    const SizedBox(height: 20,),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70,),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                            colors: [
                              Color(0xff2ECC71),
                              Color(0xff281537),
                            ]
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'GİRİŞ YAP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Hesabınız Yok Mu?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),
                            ),
                            Text(
                              "Kayıt Ol",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
