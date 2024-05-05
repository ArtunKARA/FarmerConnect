import 'package:flutter/material.dart';
import 'package:farmerconnect/farmmer/mainScreenFarmer.dart';
import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedRequestsModel.dart';
import '../../model/medicineRequestsModel.dart';
import '../../model/veterinarianRequestsModel.dart';
import '../feed/feedRequest.dart';
import '../medicine/medicineRequest.dart';
import '../../user/user.dart';

class veterinarianRequests extends StatelessWidget {
  const veterinarianRequests({Key? key}) : super(key: key);

  Future<List<veterinarianRequestsModel>> getVeterinarianRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(
          Uri.parse("https://farmerconnect.azurewebsites.net/api/veterinarian/farmer/" +
              email!));
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
              leading: Icon(Icons.home), // Yonca ikonu eklendi

              title: const Text('Anasayfa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mainScreenFarmer()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.rice_bowl), // Yonca ikonu eklendi

              title: const Text('Yem Siparişi Ver'),
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
                child: FutureBuilder<List<veterinarianRequestsModel>>(
                  future: getVeterinarianRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      final veterinarianRequestsData = snapshot.data;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Veteriner Taleplerim'),
                            leading: Icon(Icons.rice_bowl),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => veterinarianRequests()),
                                );
                              },
                            ),
                          ),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Durum')),
                              DataColumn(label: Text('Kod')),
                              DataColumn(label: Text('Teşhis')),
                            ],
                            rows: List.generate(
                              veterinarianRequestsData!.length < 5
                                  ? veterinarianRequestsData.length
                                  : 5,
                                  (index) {
                                final request = veterinarianRequestsData[index];
                                return DataRow(
                                  onSelectChanged: (selected) {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        Widget button;
                                        if (request.status == "a") {
                                          button = ElevatedButton(
                                            onPressed: () {
                                              // İptal et butonunun işlevselliği buraya yazılacak
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red, // Kırmızı renk
                                            ),
                                            child: Text('İptal Et', style: TextStyle(color: Colors.white)),
                                          );
                                        }
                                        else {
                                          // İptal et veya teslim aldım butonu olmayacaksa boş bir container döndür
                                          button = Container();
                                        }

                                        return Container(
                                          padding: const EdgeInsets.all(20.0),
                                          height: 400, // BottomSheet boyutunu artırmak için
                                          width: double.infinity, // Genişliği ekrana sığdırma
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if(request.status == "a")
                                              Text(
                                                  'Durum: Aktif',style: TextStyle(color: Colors.red),),
                                              if(request.status == "p")
                                              Text(
                                                  'Durum: Tedavi Uygulandı ',style: TextStyle(color: Colors.green),),
                                              if(request.situation == "e")
                                              Text(
                                                  'Kod: Acil ',style: TextStyle(color: Colors.red),),
                                              if(request.situation == "n")
                                              Text(
                                                  'Kod: Stabil ',style: TextStyle(color: Colors.yellow),),

                                              Text(
                                                  'Teşhis: ${request.diagnosis ?? "Bekleniyor"}'),
                                              SizedBox(height: 10),
                                              button,
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cells: <DataCell>[
                                    DataCell(Text(request.situation)),
                                    DataCell(Text(request.status)),
                                    if (request.status == "a")
                                      DataCell(Text("Aktif",
                                          style: TextStyle(color: Colors.red))),
                                    if (request.status == "p")
                                      DataCell(Text("Tedavi Uygulandı",
                                          style: TextStyle(color: Colors.green))),
                                    if (request.situation == "e")
                                      DataCell(Text("Acil",
                                          style: TextStyle(color: Colors.red))),
                                    if (request.status == "n")
                                      DataCell(Text("Stabil",
                                          style: TextStyle(color: Colors.yellow))),
                                    if (request.status != "a" &&
                                        request.status != "p")
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
