import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/feedModel.dart';


class feedRequest extends StatefulWidget {
  const feedRequest({super.key});

  @override
  State<feedRequest> createState() => _feedRequestState();
}

class _feedRequestState extends State<feedRequest> {

  Future<List<feedModel>> getPost() async {
    try {
      final response = await http
          .get(Uri.parse("https://farmerconnect.azurewebsites.net/api/feed/type"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return feedModel(
              ID: map["ID"], name: map['name'], price: map["price"]);
        }).toList();
      }
    } on SocketException {
      throw Exception("Network Connectivity Error");
    }
    throw Exception("Fetch Data Error");
  }

  TextEditingController kilogramController = TextEditingController();
  String? price;
  var selectedValue;
  int? priceInt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yem Talebi Oluştur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Yem Türü"),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<feedModel>>(
                      future: getPost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                              value: selectedValue,
                              dropdownColor: Colors.blue[100],
                              isExpanded: true,
                              hint: const Text("Yem Seçiniz"),
                              items: snapshot.data!.map((e) {
                                print("üsteki e: $e");
                                return DropdownMenuItem(
                                  value: e.ID.toString(),
                                  child: Text(e.name.toString(),
                                    // Display the title in DropdownMenuItem
                                  ),
                                );
                              }).toList(), // Change this to toList()
                              onChanged: (value) {
                                priceInt = snapshot.data!.firstWhere((element) => element.ID.toString() == value).price;
                                print(priceInt);
                                setState(() {
                                  selectedValue = value;
                                  if (selectedValue != null && kilogramController.text.isNotEmpty) {
                                      double kilogram = double.parse(kilogramController.text);
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
                Text("Kilogram"),
                TextFormField(
                  controller: kilogramController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (selectedValue != null && kilogramController.text.isNotEmpty) {
                        double kilogram = double.parse(kilogramController.text);
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
                // Butona basıldığında yapılacak işlemler
              },
              child: Text("Talep Oluştur",
                style: TextStyle(
                  color: Colors.white
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}