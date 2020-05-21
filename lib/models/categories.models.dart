
import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
    int id;
    String name;
    //String image;

    CategoriesModel({
        this.id,
        this.name = '',
      //  this.image = '',
    });

    factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
        id: json["id"],
        name: json["name"],
        //image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        //"image": image,
    };
}
