import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
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
                'Hesap Oluştur',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Ad Soyad',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2ECC71),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Telefon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2ECC71),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'E-Posta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2ECC71),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Şifre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2ECC71),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Şifre Tekrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2ECC71),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 70),
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2ECC71),
                            Color(0xff281537),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'KAYIT OL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
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
