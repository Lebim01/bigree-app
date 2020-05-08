import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));
String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    String username;
    String password;
    String name;

    RegisterModel({
        this.username = '',
        this.password = '',
        this.name = '',
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        username: json["username"],
        password: json["password"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
    };
}
