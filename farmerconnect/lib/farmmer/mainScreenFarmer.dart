import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/user/user.dart';
import 'package:flutter/material.dart';

import 'feed/feedRequest.dart';
import 'medicine/medicineRequest.dart';

class mainScreenFarmer extends StatelessWidget {
  const mainScreenFarmer({Key? key}) : super(key: key);

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
              title: const Text('Yem Talebi Oluştur'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedRequest()),
                );
              },
            ),
            ListTile(
              title: const Text('Veteriner Çağır'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => veterinarianRequest()),
                );
              },
            ),
            ListTile(
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
                    const ListTile(
                      title: Text('Yem Tedariklerim'),
                      subtitle: Text('Yem tedariklerim ve talep'),
                      leading: Icon(Icons.food_bank),
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
                      leading: Icon(Icons.local_pharmacy),
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