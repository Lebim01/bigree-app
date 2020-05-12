import 'dart:convert';

import 'package:flutter/cupertino.dart';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));
String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    String username;
    String password;
    String name;
    String image;
    String country;
    String city;

    RegisterModel({
        this.username = '',
        this.password = '',
        this.name = '',
        this.image = '',
        this.country = '',
        this.city = ''
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        username: json["username"],
        password: json["password"],
        name: json["name"],
        image: json["image"],
        country: json["country"],
        city: json["city"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "image": image,
        "country": country,
        "city": city,
    };
}
