import 'package:flutter/material.dart';

class veterinarianRequest extends StatelessWidget {
  const veterinarianRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veteriner Talebi Oluştur'),
      ),
      body: Center(
        child: Text('Feed Request'),
      ),
    );
  }
}
