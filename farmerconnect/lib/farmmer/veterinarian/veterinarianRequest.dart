import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class veterinarianRequest extends StatefulWidget {
  const veterinarianRequest({Key? key}) : super(key: key);

  @override
  _ComboBoxPageState createState() => _ComboBoxPageState();
}

class _ComboBoxPageState extends State<veterinarianRequest> {

  Future<void> postVeterianRequest(mail,situation) async {
    // Göndermek istediğiniz verileri bir harita olarak oluşturun
    Map<String, dynamic> data = {
      'mail': mail,
      'status': situation,
    };

    // Verileri JSON formatına dönüştürün
    String jsonData = json.encode(data);

    try {
      // POST isteğini göndermek istediğiniz URL'yi belirtin
      final response = await http.post(
        Uri.parse('https://farmerconnect.azurewebsites.net/api/veterinarian/farmerRequest'),
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



  String? _selectedItem;

  List<String> _items = [
    'Acil',
    'Stabil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veteriner Çağır'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              },
              items: _items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Aciliyet Durumu',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                var email = FirebaseAuth.instance.currentUser!.email;
                if (_selectedItem != null) {
                  if(_selectedItem == 'Acil'){
                    postVeterianRequest(email,"e");
                    // Acil durumda veteriner çağır
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Veteriner çağrıldı!'),
                      ),
                    );
                  } else {
                    postVeterianRequest(email,"n");
                    // Stabil durumda veteriner çağır
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Veteriner çağrıldı!'),
                      ),
                    );
                  }
                } else {
                  // Eğer hiçbir öğe seçilmediyse kullanıcıyı uyar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Durum seçiniz!'),
                    ),
                  );
                }
              },
              child: Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: veterinarianRequest(),
  ));
}
