import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/medicineModel.dart';


class medicineRequest extends StatefulWidget {
  const medicineRequest({super.key});

  @override
  State<medicineRequest> createState() => _medicineRequestState();
}

class _medicineRequestState extends State<medicineRequest> {
  Future<List<medicineModel>> getPost() async {
    try {
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/medicine/type"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return medicineModel(
              ID: map["ID"], name: map['name'], price: map["price"]);
        }).toList();
      }
    } on SocketException {
      throw Exception("Network Connectivity Error");
    }
    throw Exception("Fetch Data Error");
  }

  Future<void> postMedicineRequest(mail,medicineTypeID, amount) async {
    // Göndermek istediğiniz verileri bir harita olarak oluşturun
    Map<String, dynamic> data = {
      'mail': mail,
      'medicineTypeID': medicineTypeID,
      'amount': amount,
    };

    // Verileri JSON formatına dönüştürün
    String jsonData = json.encode(data);

    try {
      // POST isteğini göndermek istediğiniz URL'yi belirtin
      final response = await http.post(
        Uri.parse('https://farmerconnect.azurewebsites.net/api/medicine/farmerRequest'),
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

  var selectedValue;
  TextEditingController pieceController = TextEditingController();
  String? price;
  int? priceInt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İlaç Talebi Oluştur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("İlaç Türü"),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<medicineModel>>(
                      future: getPost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                              value: selectedValue,
                              dropdownColor: Colors.blue[100],
                              isExpanded: true,
                              hint: const Text("İlaç Seçiniz"),
                              items: snapshot.data!.map((e) {
                                return DropdownMenuItem(
                                  value: e.ID.toString(),
                                  child: Text(e.name.toString(),
                                    // Display the title in DropdownMenuItem
                                  ),
                                );
                              }).toList(), // Change this to toList()
                              onChanged: (value) {
                                priceInt = snapshot.data!.firstWhere((element) => element.ID.toString() == value).price.toInt();
                                print(priceInt);
                                setState(() {
                                  selectedValue = value;
                                  if (selectedValue != null && pieceController.text.isNotEmpty) {
                                    double kilogram = double.parse(pieceController.text);
                                    double calculatedPrice = priceInt! * kilogram;
                                    price = calculatedPrice.toStringAsFixed(2); // Fiyatı formatla
                                  }
                                });
                              });
                        } else if (snapshot.hasError) {
                          // Add this block for error handling
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Adet"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pieceController,
                  onChanged: (value) {
                    setState(() {
                      if (selectedValue != null && pieceController.text.isNotEmpty) {
                        double kilogram = double.parse(pieceController.text);
                        double calculatedPrice = priceInt! * kilogram;
                        price = calculatedPrice.toStringAsFixed(2); // Fiyatı formatla
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fiyat"),
                TextField(
                  enabled: false, // Kullanıcı tarafından değiştirilemez
                  controller: TextEditingController(text: price),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2ECC71),
              ),
              onPressed: () {
                if(selectedValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen yem türü seçiniz!'),
                    ),
                  );
                  return;
                } else if(pieceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen kilogram giriniz!'),
                    ),
                  );
                  return;
                } else if(price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fiyat hesaplanırken bir hata oluştu!'),
                    ),
                  );
                  return;
                } else {
                  var email = FirebaseAuth.instance.currentUser!.email;
                  postMedicineRequest(email,selectedValue, pieceController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Talep oluşturuldu!'),
                    ),
                  );
                }
              },
              child: Text("Talep Oluştur",
                  style: TextStyle(color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}