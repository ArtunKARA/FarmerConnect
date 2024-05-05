import 'package:farmerconnect/user/userDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/userDatas.dart';
import '../global/toast.dart';

class user extends StatelessWidget {
  const user({Key? key}) : super(key: key);

  Future<userDatas?> getPost() async {
    try {
      final response = await http.get(Uri.parse("https://farmerconnect.azurewebsites.net/api/user/userData/artun@email.com"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        // İlk kullanıcıyı döndür
        if (body.isNotEmpty) {
          final map = body.first as Map<String, dynamic>;
          return userDatas(
              ID: map["ID"],
              userName: map['userName'],
              mail: map["mail"],
              password: map["password"],
              userType: map["userType"],
              name: map["name"],
              surname: map["surname"],
              telno: map["telno"],
              farmName: map["farmName"],
              farmAdres: map["farmAdres"],
              area: map["area"]);
        }
      }
    } on SocketException {
      throw Exception("Network Connectivity Error");
    }
    throw Exception("Fetch Data Error");
  }

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
            FutureBuilder<userDatas?>(
              future: getPost(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata oluştu: ${snapshot.error}'));
                  } else {
                    final user = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "İsim:"+user!.name,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Soyisim:"+user.surname,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ]
                        ),
                        SizedBox(height: 13.0),
                        Text("Kurum: "+user.farmName,
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
                                  if(user.area == null)
                                    Center(
                                      child: Text(
                                        "Bölge: Tanımsız",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                  else if(user.area == "m")
                                    Center(
                                      child: Text(
                                        "Bölge: Marmara",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                  else if (user.area == "e")
                                    Center(
                                      child: Text(
                                        "Bölge: Ege",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                    else if (user.area == "k")
                                        Center(
                                          child: Text(
                                            "Bölge: Karadeniz",
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        )
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
                                  if (user.userType == "f")
                                    Center(
                                      child: Text(
                                        "Kullanıcı Türü: Çiftçi",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                  else if (user.userType == "s")
                                    Center(
                                      child: Text(
                                        "Kullanıcı Türü: Tedarikçi",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                    else if (user.userType == "a")
                                      Center(
                                        child: Text(
                                          "Kullanıcı Türü: Admin",
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      )
                                      else if (user.userType == "v")
                                        Center(
                                          child: Text(
                                            "Kullanıcı Türü: Veteriner Hekim",
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        )
                                  else
                                    Center(
                                      child: Text(
                                        "Kullanıcı Türü: Tanımsız",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    )
                                ]
                            ),
                          ),
                        ),
                        ],
                      );
                    }
                  }
                },
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
