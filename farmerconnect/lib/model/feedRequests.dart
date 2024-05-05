// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:farmerconnect/farmmer/feed/feedRequest.dart';

List<feedRequests> dropdownItemsModelFromJson(String str) =>
    List<feedRequests>.from(
        json.decode(str).map((x) => feedRequests.fromJson(x)));

String dropdownItemsModelToJson(List<feedRequests> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class feedRequests {
  int TalepID;
  String YemAdi;
  int Miktar;
  String Durum;
  String IstekTarihi;
  String? TeslimTarihi;

  feedRequests({
    required this.TalepID,
    required this.YemAdi,
    required this.Miktar,
    required this.Durum,
    required this.IstekTarihi,
    this.TeslimTarihi,
  });

  factory feedRequests.fromJson(Map<String, dynamic> json) =>
      feedRequests(
        TalepID: json["TalepID"],
        YemAdi: json["YemAdı"],
        Miktar: json["Miktar"],
        Durum: json["Durum"],
        IstekTarihi: json["IstekTarihi"],
        TeslimTarihi: json["TeslimTarihi"],
      );

  Map<String, dynamic> toJson() => {
    "TalepID": TalepID,
    "YemAdı": YemAdi,
    "Miktar": Miktar,
    "Durum": Durum,
    "IstekTarihi": IstekTarihi,
    "TeslimTarihi": TeslimTarihi,
  };
}