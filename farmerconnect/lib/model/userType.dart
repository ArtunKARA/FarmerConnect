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
  String userTypes;

  userType({
    required this.userTypes,
  });

  factory userType.fromJson(Map<String, dynamic> json) =>
      userType(
        userTypes: json["userType"],
      );

  Map<String, dynamic> toJson() => {
    "userType": userTypes,
  };
}