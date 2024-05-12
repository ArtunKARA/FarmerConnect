import 'package:farmerconnect/farmmer/mainScreenFarmer.dart';
import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedRequestsModel.dart';
import '../../model/medicineRequestsModel.dart';
import '../feed/feedRequest.dart';
import '../medicine/medicineRequest.dart';
import '../../user/user.dart';

class medicineRequests extends StatelessWidget {
  const medicineRequests({Key? key}) : super(key: key);

  Future<List<medicineRequestsModel>> getMedicineRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(
          Uri.parse("https://farmerconnect.azurewebsites.net/api/medicine/farmer/" +
              email!));
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

  Future<void> getMedicineDelivered(feedRequestID) async {
    try {
      // POST isteğini göndermek istediğiniz URL'yi belirtin
      final response = await http.get(
        Uri.parse('https://farmerconnect.azurewebsites.net/api/medicine/farmerRequestDelivered/'+ feedRequestID),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // Yanıtın durumunu kontrol edin
      if (response.statusCode == 200) {
        print('Veri başarıyla gönderildi');
        print('Sunucu yanıtı: ${response.body}');
      } else {
        print('Veri gönderilirken bir hata oluştu: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('İstek sırasında bir hata oluştu: $e');
    }
  }

  Future<void> getMedicineCancel(feedRequestID) async {
    try {
      // POST isteğini göndermek istediğiniz URL'yi belirtin
      final response = await http.get(
        Uri.parse('https://farmerconnect.azurewebsites.net/api/medicine/farmerRequestCanceled/' + feedRequestID),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Veriyi JSON formatında gönderin
      );

      // Yanıtın durumunu kontrol edin
      if (response.statusCode == 200) {
        print('Veri başarıyla gönderildi');
        print('Sunucu yanıtı: ${response.body}');
      } else {
        print('Veri gönderilirken bir hata oluştu: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('İstek sırasında bir hata oluştu: $e');
    }
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
                child: FutureBuilder<List<medicineRequestsModel>>(
                  future: getMedicineRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      final feedRequestsData = List.from(snapshot.data!.reversed);
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('İlaç Siparişlerim'),
                            leading: Icon(Icons.rice_bowl),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => medicineRequests()),
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
                              feedRequestsData!.length,
                                  (index) {
                                final request = feedRequestsData[index];
                                return DataRow(
                                  onSelectChanged: (selected) {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        Widget button;
                                        if (request.status == "r") {
                                          button = ElevatedButton(
                                            onPressed: () {
                                              getMedicineCancel(request.ID.toString());
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => mainScreenFarmer()),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red, // Kırmızı renk
                                            ),
                                            child: Text('İptal Et', style: TextStyle(color: Colors.white)),
                                          );
                                        } else if (request.status == "s") {
                                          button = ElevatedButton(
                                            onPressed: () {
                                              getMedicineDelivered(request.ID.toString());
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => mainScreenFarmer()),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green, // Yeşil renk
                                            ),
                                            child: Text('Teslim Aldım', style: TextStyle(color: Colors.white)),
                                          );
                                        } else {
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
                                              Text(
                                                  'İlaç Adı: ${request.name}'),
                                              Text(
                                                  'Miktar: ${request.amount}'),
                                              Text(
                                                  'Durum: ${request.status}'),
                                              Text(
                                                  'Sipariş Tarihi: ${request.requestDate}'),
                                              Text(
                                                  'Teslimat Tarihi: ${request.deliveryDate ?? "Bekleniyor"}'),
                                              SizedBox(height: 10),
                                              button,
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cells: <DataCell>[
                                    DataCell(Text(request.name)),
                                    DataCell(Text(request.amount.toString())),
                                    if (request.status == "r")
                                      DataCell(Text("Talepte",
                                          style: TextStyle(color: Colors.yellow))),
                                    if (request.status == "s")
                                      DataCell(Text("Tedarikte",
                                          style: TextStyle(color: Colors.orange))),
                                    if (request.status == "d")
                                      DataCell(Text("Teslim Edildi",
                                          style: TextStyle(color: Colors.green))),
                                    if (request.status == "c")
                                      DataCell(Text("İptal Edildi",
                                          style: TextStyle(color: Colors.red))),
                                    if (request.status != "r" &&
                                        request.status != "s" &&
                                        request.status != "d" &&
                                        request.status != "c")
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
