import 'dart:convert';
import 'dart:io';

import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/feedRequestsModel.dart';
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
                      // Veri yükleniyor ise bu kısım çalışır
                      return CircularProgressIndicator(); // veya bir yükleniyor animasyonu gösterebilirsiniz
                    } else if (snapshot.hasError) {
                      // Veri yüklenirken hata oluştu ise bu kısım çalışır
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      // Veri başarılı bir şekilde alındı ise bu kısım çalışır
                      final feedRequestsData = snapshot.data;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Yem Tedariklerim'),
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
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text('Veteriner Aksiyonları'),
                      subtitle: Text('Veteriner aksiyonlarım ve talep'),
                      leading: Icon(Icons.medical_services),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Tür')),
                        DataColumn(label: Text('Miktar')),
                        DataColumn(label: Text('Durum')),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text('İlaç Taleplerim'),
                      subtitle: Text('İlaç talep ve durum'),
                      leading: Icon(Icons.vaccines),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Tür')),
                        DataColumn(label: Text('Miktar')),
                        DataColumn(label: Text('Durum')),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}