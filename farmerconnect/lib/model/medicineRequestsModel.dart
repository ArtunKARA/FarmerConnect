// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:farmerconnect/farmmer/feed/feedRequest.dart';

List<medicineRequestsModel> dropdownItemsModelFromJson(String str) =>
    List<medicineRequestsModel>.from(
        json.decode(str).map((x) => medicineRequestsModel.fromJson(x)));

String dropdownItemsModelToJson(List<medicineRequestsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class medicineRequestsModel {
  int ID;
  String name;
  int amount;
  String status;
  String requestDate;
  String? deliveryDate;

  medicineRequestsModel({
    required this.ID,
    required this.name,
    required this.amount,
    required this.status,
    required this.requestDate,
    this.deliveryDate,
  });

  factory medicineRequestsModel.fromJson(Map<String, dynamic> json) =>
      medicineRequestsModel(
        ID: json["ID"],
        name: json["name"],
        amount: json["amount"],
        status: json["status"],
        requestDate: json["requestDate"],
        deliveryDate: json["deliveryDate"],
      );

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "name": name,
    "amount": amount,
    "status": status,
    "requestDate": requestDate,
    "deliveryDate": deliveryDate,
  };
}