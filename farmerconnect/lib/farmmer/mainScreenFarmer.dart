import 'dart:convert';
import 'dart:io';

import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/feedRequestsModel.dart';
import '../model/medicineRequestsModel.dart';
import '../model/veterinarianRequestsModel.dart';
import 'feed/feedRequest.dart';
import 'feed/feedRequests.dart';
import 'medicine/medicineRequest.dart';

class mainScreenFarmer extends StatelessWidget {
  const mainScreenFarmer({Key? key}) : super(key: key);

  Future<List<feedRequestsModel>> getFeedRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/farmer/"+ email!));
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

  }Future<List<medicineRequestsModel>> getMedicineRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/farmer/"+ email!));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return medicineRequestsModel(
              ID: map["ID"],
              name: map['name'],
              amount: map["amount"],
              status: map["status"],
              requestDate: map["requestDate"],
              deliveryDate: map["deliveryDate"]);
        }).toList();
      }
    } on SocketException {
      throw Exception("Network Connectivity Error");
    }
    throw Exception("Fetch Data Error");
  }

  Future<List<veterinarianRequestsModel>> getVeterinarianRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/farmer/"+ email!));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return veterinarianRequestsModel(
              ID: map["ID"],
              status: map['status'],
              requestDate: map["requestDate"],
              diagnosis: map["diagnosis"],
              situation: map["situation"]);
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
        title: const Text('FarmerConnect', style: TextStyle(color: Colors.white),),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => user()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Hızlı Erişimler", style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(
                color: const Color(0xff2ECC71),
              ),
            ),
            ListTile(
              leading: Icon(Icons.rice_bowl), // Yonca ikonu eklendi

              title: const Text('Yem Talebi Oluştur'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedRequest()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_information), // Yonca ikonu eklendi

              title: const Text('Veteriner Çağır'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => veterinarianRequest()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.vaccines), // Yonca ikonu eklendi

              title: const Text('İlaç Sipariş Et'),
              onTap: (){
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
                                  MaterialPageRoute(builder: (context) => feedRequests()),
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
                              feedRequestsData!.length < 5 ? feedRequestsData.length : 5,
                                  (index) {
                                final request = feedRequestsData[index];
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(request.YemAdi)),
                                    DataCell(Text(request.Miktar.toString())),
                                    if(request.Durum == "r")
                                      DataCell(Text("Talepte", style: TextStyle(color: Colors.yellow))
                                      )
                                    else if(request.Durum == "s")
                                      DataCell(Text("Tedarikte", style: TextStyle(color: Colors.orange))
                                      )
                                    else if(request.Durum == "d")
                                        DataCell(Text("Teslim Edildi", style: TextStyle(color: Colors.green))
                                        )
                                      else if(request.Durum == "c")
                                          DataCell(Text("İptal Edildi", style: TextStyle(color: Colors.red))
                                          )
                                        else
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

              Card(
                child: FutureBuilder<List<medicineRequestsModel>>(
                  future: getMedicineRequest(),
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
                            title: Text('İlaç Tedariklerim'),
                            subtitle: Text('Yem tedariklerim ve talep'),
                            leading: Icon(Icons.rice_bowl),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => feedRequests()),
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
                              feedRequestsData!.length < 5 ? feedRequestsData.length : 5,
                                  (index) {
                                final request = feedRequestsData[index];
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(request.name)),
                                    DataCell(Text(request.amount.toString())),
                                    if(request.status == "r")
                                      DataCell(Text("Talepte", style: TextStyle(color: Colors.yellow))
                                      )
                                    else if(request.status == "s")
                                      DataCell(Text("Tedarikte", style: TextStyle(color: Colors.orange))
                                      )
                                    else if(request.status == "d")
                                        DataCell(Text("Teslim Edildi", style: TextStyle(color: Colors.green))
                                        )
                                      else if(request.status == "c")
                                          DataCell(Text("İptal Edildi", style: TextStyle(color: Colors.red))
                                          )
                                        else
                                          DataCell(Text(request.status)),
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

              Card(
                child: FutureBuilder<List<veterinarianRequestsModel>>(
                  future: getVeterinarianRequest(),
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
                            title: Text('Veteriner Taleplerim'),
                            leading: Icon(Icons.medical_information),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => feedRequests()),
                                );
                              },
                            ),
                          ),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Kod')),
                              DataColumn(label: Text('Durum')),
                            ],
                            rows: List.generate(
                              feedRequestsData!.length < 5 ? feedRequestsData.length : 5,
                                  (index) {
                                final request = feedRequestsData[index];
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(request.situation)),
                                    DataCell(Text(request.status)),
                                    if(request.status == "a")
                                      DataCell(Text("Aktif", style: TextStyle(color: Colors.red))
                                      )
                                    else if(request.status == "p")
                                      DataCell(Text("Veteriner Yolda", style: TextStyle(color: Colors.green))
                                      )
                                        else
                                          DataCell(Text(request.status)),
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
