// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:farmerconnect/farmmer/feed/feedRequest.dart';

List<veterinarianRequestsModel> dropdownItemsModelFromJson(String str) =>
    List<veterinarianRequestsModel>.from(
        json.decode(str).map((x) => veterinarianRequestsModel.fromJson(x)));

String dropdownItemsModelToJson(List<veterinarianRequestsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class veterinarianRequestsModel {
  int ID;
  String status;
  String requestDate;
  String? diagnosis;
  String situation;
  String farmAdres;

  veterinarianRequestsModel({
    required this.ID,
    required this.status,
    required this.requestDate,
    required this.diagnosis,
    required this.situation,
    required this.farmAdres,
  });

  factory veterinarianRequestsModel.fromJson(Map<String, dynamic> json) =>
      veterinarianRequestsModel(
        ID: json["ID"],
        status: json["status"],
        requestDate: json["requestDate"],
        diagnosis: json["diagnosis"],
        situation: json["situation"],
          farmAdres : json["farmAdres"],
      );

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "status": status,
    "requestDate": requestDate,
    "diagnosis": diagnosis,
    "situation": situation,
    "farmAdres": farmAdres,
  };
}