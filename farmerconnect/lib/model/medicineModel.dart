// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

List<medicineModel> dropdownItemsModelFromJson(String str) =>
    List<medicineModel>.from(
        json.decode(str).map((x) => medicineModel.fromJson(x)));

String dropdownItemsModelToJson(List<medicineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class medicineModel {
  int ID;
  String name;
  int price;

  medicineModel({
    required this.ID,
    required this.name,
    required this.price,
  });

  factory medicineModel.fromJson(Map<String, dynamic> json) =>
      medicineModel(
        ID: json["ID"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "name": name,
    "price": price,
  };
}