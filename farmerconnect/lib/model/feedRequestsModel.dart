// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:farmerconnect/farmmer/feed/feedRequest.dart';

List<feedRequestsModel> dropdownItemsModelFromJson(String str) =>
    List<feedRequestsModel>.from(
        json.decode(str).map((x) => feedRequestsModel.fromJson(x)));

String dropdownItemsModelToJson(List<feedRequestsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class feedRequestsModel {
  int TalepID;
  String YemAdi;
  double Miktar;
  String Durum;
  String IstekTarihi;
  String? TeslimTarihi;

  feedRequestsModel({
    required this.TalepID,
    required this.YemAdi,
    required this.Miktar,
    required this.Durum,
    required this.IstekTarihi,
    this.TeslimTarihi,
  });

  factory feedRequestsModel.fromJson(Map<String, dynamic> json) =>
      feedRequestsModel(
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