// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

List<feedModel> dropdownItemsModelFromJson(String str) =>
    List<feedModel>.from(
        json.decode(str).map((x) => feedModel.fromJson(x)));

String dropdownItemsModelToJson(List<feedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class feedModel {
  int ID;
  String name;
  double price;

  feedModel({
    required this.ID,
    required this.name,
    required this.price,
  });

  factory feedModel.fromJson(Map<String, dynamic> json) =>
      feedModel(
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