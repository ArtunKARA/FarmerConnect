// To parse this JSON data, do
//
//     final dropdownItemsModel = dropdownItemsModelFromJson(jsonString);

import 'dart:convert';

List<userDatas> dropdownItemsModelFromJson(String str) =>
    List<userDatas>.from(
        json.decode(str).map((x) => userDatas.fromJson(x)));

String dropdownItemsModelToJson(List<userDatas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class userDatas {
  int ID;
  String userName;
  String mail;
  String password;
  String userType;
  String name;
  String surname;
  String telno;
  String farmName;
  String farmAdres;
  String area;


  userDatas({
    required this.ID,
    required this.userName,
    required this.mail,
    required this.password,
    required this.userType,
    required this.name,
    required this.surname,
    required this.telno,
    required this.farmName,
    required this.farmAdres,
    required this.area,
  });

  factory userDatas.fromJson(Map<String, dynamic> json) =>
      userDatas(
        ID: json["ID"],
        userName: json["userName"],
        mail: json["mail"],
        password: json["password"],
        userType: json["userType"],
        name: json["name"],
        surname: json["surname"],
        telno: json["telno"],
        farmName: json["farmName"],
        farmAdres: json["farmAdres"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "userName": userName,
    "mail": mail,
    "password": password,
    "userType": userType,
    "name": name,
    "surname": surname,
    "telno": telno,
    "farmName": farmName,
    "farmAdres": farmAdres,
    "area": area,
  };
}