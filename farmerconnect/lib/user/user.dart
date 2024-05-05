import 'package:farmerconnect/user/userDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global/toast.dart';

class user extends StatelessWidget {
  const user({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Ekranı'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "İsim:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Soyisim:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ]
            ),
            SizedBox(height: 13.0),
            Text("Kurum:",
                style: TextStyle(fontSize: 18.0)
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(2.0), // İstenilen padding değeri
              child: Container(
                padding: EdgeInsets.all(8.0), // İçerik içindeki padding değeri
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Kenarlık rengi
                  borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                ),
                child: Row(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Bölge:",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.0), // İstenilen padding değeri
              child: Container(
                padding: EdgeInsets.all(8.0), // İçerik içindeki padding değeri
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Kenarlık rengi
                  borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                ),
                child: Row(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Kullanıcı Türü:",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ECC71),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  // Profili düzenleme sayfasına gitmek için Navigator kullanabilirsiniz
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => userDetails()),
                  );
                },
                child: Text("Bilgilerimi Güncelle",
                    style: TextStyle(color: Colors.white)
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                  showToast(message: "Çıkış yapıldı");
                },
                child: Text("Çıkış Yap",
                    style: TextStyle(color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
