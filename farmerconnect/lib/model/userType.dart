// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

List<userType> dropdownItemsModelFromJson(String str) =>
    List<userType>.from(
        json.decode(str).map((x) => userType.fromJson(x)));

String dropdownItemsModelToJson(List<userType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class userType {
  int ID;
  String name;
  int price;

  userType({
    required this.ID,
    required this.name,
    required this.price,
  });

  factory userType.fromJson(Map<String, dynamic> json) =>
      userType(
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