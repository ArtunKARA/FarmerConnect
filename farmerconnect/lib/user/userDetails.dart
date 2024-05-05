import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/userDatas.dart';

class userDetails extends StatelessWidget {
  const userDetails({Key? key}) : super(key: key);

  // API'den kullanıcı bilgilerini alacak olan fonksiyon
  Future<userDatas?> getPost() async {
    try {
      var mail = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(Uri.parse("https://farmerconnect.azurewebsites.net/api/user/userData/"+mail!));
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
        title: Text('Kullanıcı Bilgileri Güncelle'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<userDatas?>(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: TextEditingController(text: user?.name ?? ''),
                      decoration: InputDecoration(labelText: 'İsim'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: TextEditingController(text: user?.surname ?? ''),
                      decoration: InputDecoration(labelText: 'Soyisim'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: TextEditingController(text: user?.farmName ?? ''),
                      decoration: InputDecoration(labelText: 'Kurum'),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      maxLines: 5,
                      controller: TextEditingController(text: user?.farmAdres ?? ''),
                      decoration: InputDecoration(labelText: 'Adres', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: TextEditingController(text: user?.telno ?? ''),
                      decoration: InputDecoration(labelText: 'Telefon Numarası'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: TextEditingController(text: user?.mail ?? ''),
                      decoration: InputDecoration(labelText: 'E-posta'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Kaydet butonuna basıldığında yapılacak işlemler
                      },
                      child: Text('Kaydet'),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
      resizeToAvoidBottomInset: true, // Klavye açıldığında ekranı otomatik olarak yukarı kaydırır
    );
  }
}

