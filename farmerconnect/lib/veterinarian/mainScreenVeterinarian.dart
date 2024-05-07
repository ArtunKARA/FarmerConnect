import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/model/veterinarianRequestsModel.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedRequestsModel.dart';
import '../../user/user.dart';

class mainScreenVeterinarian extends StatelessWidget {
  const mainScreenVeterinarian({Key? key}) : super(key: key);

  Future<List<veterinarianRequestsModel>> getVeterianRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(
          Uri.parse("https://farmerconnect.azurewebsites.net/api/veterinarian/veterinarian/" +
              email!));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return veterinarianRequestsModel(
              ID : map["ID"],
              status : map["status"],
              requestDate : map["requestDate"],
              diagnosis : map["diagnosis"],
              situation : map["situation"],
              farmAdres : map["farmAdres"],
          );
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
        backgroundColor: const Color(0xFFD2B48C),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: FutureBuilder<List<veterinarianRequestsModel>>(
                  future: getVeterianRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      final reversedData = snapshot.data;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Yem Siparişlerim'),
                            leading: Icon(Icons.rice_bowl),
                          ),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Talep Tarihi')),
                              DataColumn(label: Text('Kod')),
                              DataColumn(label: Text('Durum')),
                            ],
                            rows: List.generate(
                              reversedData!.length < 5
                                  ? reversedData.length
                                  : reversedData.length - 1,
                                  (index) {
                                final request = reversedData[index];
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
                                              Text("Talep Tarihi: " + request.requestDate.substring(0,11)),
                                              Text("Durum: " + request.status),
                                              Text("Aciliyet Durumu: " + request.situation),
                                              Text("Çiftlik Adresi: " + request.farmAdres!),
                                              ButtonBar(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Veteriner çağır
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('İş üzerine alındı'),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('ONAYLA'),
                                                  ),

                                                ],
                                              ),
                                              // Diğer bilgiler buraya eklenebilir...
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cells: <DataCell>[
                                    DataCell(Text(request.requestDate.substring(0,11) ?? "Bekleniyor")),
                                    if (request.situation == "a")
                                      DataCell(Text("Acil", style: TextStyle(color: Colors.red)))
                                    else if (request.situation == "n")
                                      DataCell(Text("Stabil", style: TextStyle(color: Colors.green)))
                                    else
                                      DataCell(Text(request.status)),
                                    if (request.status == "a")
                                      DataCell(Text("Aktif", style: TextStyle(color: Colors.red)))
                                    else if (request.status == "p")
                                      DataCell(Text("Veteriner Yolda", style: TextStyle(color: Colors.green)))
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
