import 'package:farmerconnect/farmmer/mainScreenFarmer.dart';
import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/supplier/mainScreenSupplier.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/feedRequestsModel.dart';
import '../../user/user.dart';

class activeFeedRequest extends StatelessWidget {
  const activeFeedRequest({Key? key}) : super(key: key);

  Future<List<feedRequestsModel>> getFeedRequest() async {
    try {
      var email = FirebaseAuth.instance.currentUser!.email;
      final response = await http.get(
          Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/all/"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return feedRequestsModel(
              TalepID: map["TalepID"],
              YemAdi: map['YemAdı'],
              Miktar: map["Miktar"].toDouble(),
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

  Future<void> postFeedRequestSupply(id,deliveryDate,mail) async {
    // Göndermek istediğiniz verileri bir harita olarak oluşturun
    Map<String, dynamic> data = {
      'id': id,
      'deliveryDate': deliveryDate,
      'mail': mail,
    };

    // Verileri JSON formatına dönüştürün
    String jsonData = json.encode(data);

    try {
      // POST isteğini göndermek istediğiniz URL'yi belirtin
      final response = await http.post(
        Uri.parse('https://farmerconnect.azurewebsites.net/api/feed/supplierRequestSupply'),
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
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3498DB),
        title: const Text(
          'FarmerConnect',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mainScreenSupplier()),
                );
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
                child: FutureBuilder<List<feedRequestsModel>>(
                  future: getFeedRequest(),
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
                            title: Text('Yem Siparişlerim'),
                            leading: Icon(Icons.rice_bowl),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mainScreenSupplier()),
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
                                        if (request.Durum == "r") {
                                          button = Column(
                                            children: [
                                              if(request.Durum == "r")
                                                Text("Gidilecek Tarih: " + now.toString().substring(0,11)),
                                              if(request.Durum == "r")
                                                ElevatedButton(
                                                    child: const Text('Teslimat Tarihi Giriniz'),
                                                    onPressed: () async {
                                                      final DateTime? date = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(2000),
                                                        lastDate: DateTime(2025),
                                                      );
                                                      if(date != null){
                                                        now = date;
                                                      }
                                                    }
                                                ),
                                              ButtonBar(
                                                children: [
                                                  if(request.Durum == "r")
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        postFeedRequestSupply(request.TalepID, now.toString().substring(0,11), FirebaseAuth.instance.currentUser!.email.toString());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => mainScreenSupplier()),
                                                        );
                                                      },
                                                      child: Text("Siparişi üsütüme al"),
                                                    ),
                                                ],
                                              ),
                                            ],
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
                                                  'Yem Adı: ${request.YemAdi}'),
                                              Text(
                                                  'Miktar: ${request.Miktar}'),
                                              Text(
                                                  'Durum: Tedarikte'),
                                              Text(
                                                  'Sipariş Tarihi: ${request.IstekTarihi}'),
                                              Text(
                                                  'Teslimat Tarihi: ${request.TeslimTarihi ?? "Bekleniyor"}'),
                                              SizedBox(height: 10),
                                              button,
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
                                      DataCell(Text("Tedarikte",
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
