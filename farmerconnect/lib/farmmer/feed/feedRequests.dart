import 'package:farmerconnect/farmmer/mainScreenFarmer.dart';
import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/user/user.dart';
import 'package:flutter/material.dart';
import 'package:farmerconnect/farmmer/feed/feedRequest.dart';
import 'package:farmerconnect/farmmer/medicine/medicineRequest.dart';

class feedRequests extends StatelessWidget {
  const feedRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2ECC71),
        title: const Text('Yem Taleplerim', style: TextStyle(color: Colors.white),),
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
              leading: Icon(Icons.home), // İkon eklendi
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
              title: const Text('Yem Talebi Oluştur'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedRequests()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services), // Yonca ikonu eklendi

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
                child: Column(
                  children: <Widget>[
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Tür')),
                        DataColumn(label: Text('Miktar')),
                        DataColumn(label: Text('Durum')),
                        DataColumn(label: Text('Durum')),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 1')),
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
                            DataCell(Text('Row 1')),

                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),

                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
                            DataCell(Text('Row 1')),

                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 2')),
                            DataCell(Text('Row 1')),
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