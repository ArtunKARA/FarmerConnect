import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/model/veterinarianRequestsModel.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedRequestsModel.dart';
import '../../user/user.dart';
import 'allVeterinarianRequests.dart';

class mainScreenVeterinarian extends StatefulWidget {
  const mainScreenVeterinarian({Key? key}) : super(key: key);

  @override
  State<mainScreenVeterinarian> createState() => _mainScreenVeterinarian();
  }


  @override
  class _mainScreenVeterinarian extends State<mainScreenVeterinarian> {
    var tani = "";
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

    Future<void> postVeterianDiagnosis(diagnosis,id) async {
      // Göndermek istediğiniz verileri bir harita olarak oluşturun
      Map<String, dynamic> data = {
        'diagnosis': diagnosis,
        'id': id,
      };

      // Verileri JSON formatına dönüştürün
      String jsonData = json.encode(data);

      try {
        // POST isteğini göndermek istediğiniz URL'yi belirtin
        final response = await http.post(
          Uri.parse('https://farmerconnect.azurewebsites.net/api/veterinarian/veterinarianRequestDiagnosis'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          // Veriyi JSON formatında gönderin
          body: jsonData,
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
                              title: Text('Üzerimdeki İstekler'),
                              leading: Icon(Icons.request_page_outlined),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AllVeterinarianRequests()),
                                  );
                                },
                              ),
                            ),
                            DataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Talep Tarihi')),
                                DataColumn(label: Text('Kod')),
                                DataColumn(label: Text('Durum')),
                              ],
                              rows: List.generate(
                                reversedData!.length,
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
                                                Text("Durum: " + (request.status == "a" ? "Aktif" : "Pasif")),
                                                Text("Aciliyet Durumu: " + (request.situation == "e" ? "Acil" : "Stabil")),
                                                Text("Çiftlik Adresi: " + request.farmAdres!),
                                                Text("Teşhis: ${request.diagnosis}" ?? "Bekleniyor"),
                                                if(request.status == "a")
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText: 'Tanı',
                                                      hintText: 'Tanı giriniz',
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tani = value;
                                                      });
                                                    },
                                                  ),
                                                ButtonBar(
                                                  children: [
                                                    if(request.status == "a")
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          postVeterianDiagnosis(tani,request.ID);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => mainScreenVeterinarian()),
                                                          );
                                                        },
                                                        child: Text("Tedavi Edildi"),
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
                                      if (request.situation == "e")
                                        DataCell(Text("Acil", style: TextStyle(color: Colors.red)))
                                      else if (request.situation == "n")
                                        DataCell(Text("Stabil", style: TextStyle(color: Colors.green)))
                                      else
                                        DataCell(Text(request.status)),
                                      if (request.status == "a")
                                        DataCell(Text("Aktif", style: TextStyle(color: Colors.red)))
                                      else if (request.status == "p")
                                        DataCell(Text("Tedavi Edildi", style: TextStyle(color: Colors.green)))
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
