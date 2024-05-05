import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedRequestsModel.dart';
import '../medicine/medicineRequest.dart';
import 'feedRequest.dart';
import '../../user/user.dart';

class feedRequests extends StatelessWidget {
  const feedRequests({Key? key}) : super(key: key);

  Future<List<feedRequestsModel>> getFeedRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(
          Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/farmer/" +
              email!));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return feedRequestsModel(
              TalepID: map["TalepID"],
              YemAdi: map['YemAdı'],
              Miktar: map["Miktar"],
              Durum: map["Durum"],
              IstekTarihi: map["IstekTarihi"],
              TeslimTarihi: map["TeslimTarihi"]);
        }).toList();
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
        backgroundColor: const Color(0xff2ECC71),
        title: const Text(
          'FarmerConnect',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => user()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        width: 300,
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Hızlı Erişimler",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: const Color(0xff2ECC71),
              ),
            ),
            ListTile(
              leading: Icon(Icons.rice_bowl), // Yonca ikonu eklendi

              title: const Text('Yem Talebi Oluştur'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedRequest()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_information), // Yonca ikonu eklendi

              title: const Text('Veteriner Çağır'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => veterinarianRequest()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.vaccines), // Yonca ikonu eklendi

              title: const Text('İlaç Sipariş Et'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => medicineRequest()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: FutureBuilder<List<feedRequestsModel>>(
                  future: getFeedRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      final feedRequestsData = snapshot.data;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Yem Siparişlerim'),
                            leading: Icon(Icons.rice_bowl),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => feedRequests()),
                                );
                              },
                            ),
                          ),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Tür')),
                              DataColumn(label: Text('Miktar')),
                              DataColumn(label: Text('Durum')),
                            ],
                            rows: List.generate(
                              feedRequestsData!.length < 5
                                  ? feedRequestsData.length
                                  : 5,
                                  (index) {
                                final request = feedRequestsData[index];
                                return DataRow(
                                  onSelectChanged: (selected) {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: const EdgeInsets.all(20.0),
                                          height: 400, // BottomSheet boyutunu artırmak için
                                          width: double.infinity, // Genişliği ekrana sığdırma
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Yem Adı: ${request.YemAdi}'),
                                              SizedBox(height: 15,),
                                              Text(
                                                  'Miktar: ${request.Miktar}'),
                                              SizedBox(height: 15,),
                                              if (request.Durum == "r")
                                              Text(
                                                  'Durum: Talepte'),

                                              if (request.Durum == "s")
                                              Text(
                                                  'Durum: Sipariş Yolda'),

                                              if (request.Durum == "d")
                                              Text(
                                                  'Durum: Teslim Edildi'),

                                              if (request.Durum == "c")
                                              Text(
                                                  'Durum: İptal Edildi'),
                                              SizedBox(height: 15,),
                                              Text(
                                                  'Sipariş Tarihi: ${request.IstekTarihi}'),
                                              SizedBox(height: 15,),
                                              Text(
                                                  'Teslimat Tarihi: ${request.TeslimTarihi ?? "Bekleniyor"}'),
                                              // Diğer bilgiler buraya eklenebilir...
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cells: <DataCell>[
                                    DataCell(Text(request.YemAdi)),
                                    DataCell(Text(request.Miktar.toString())),
                                    if (request.Durum == "r")
                                      DataCell(Text("Talepte",
                                          style: TextStyle(color: Colors.yellow))),
                                    if (request.Durum == "s")
                                      DataCell(Text("Sipariş Yolda",
                                          style: TextStyle(color: Colors.orange))),
                                    if (request.Durum == "d")
                                      DataCell(Text("Teslim Edildi",
                                          style: TextStyle(color: Colors.green))),
                                    if (request.Durum == "c")
                                      DataCell(Text("İptal Edildi",
                                          style: TextStyle(color: Colors.red))),
                                    if (request.Durum != "r" &&
                                        request.Durum != "s" &&
                                        request.Durum != "d" &&
                                        request.Durum != "c")
                                      DataCell(Text(request.Durum)),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
