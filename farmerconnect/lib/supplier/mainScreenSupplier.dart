import 'package:farmerconnect/farmmer/veterinarian/veterinarianRequest.dart';
import 'package:farmerconnect/user/user.dart';
import 'package:flutter/material.dart';


class mainScreenSupplier extends StatelessWidget {
  const mainScreenSupplier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2ECC71),
        title: const Text('FarmerConnect', style: TextStyle(color: Colors.white),),
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
                      title: Text('Yem Siparişleri'),
                      subtitle: Text('Yem siparişlerinizi buradan görebilisiniz.'),
                      leading: Icon(Icons.food_bank),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Çiftlik')),
                        DataColumn(label: Text('Yem Türü')),
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
                      title: Text('İlaç Siparişleri'),
                      subtitle: Text('İlaç siparişlerinizi buradan görebilisiniz.'),
                      leading: Icon(Icons.medical_services),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Çiftlik')),
                        DataColumn(label: Text('Tür')),
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