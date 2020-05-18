// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) => EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
    String id;
    String title;
    String description;
    double price;
    String location;
    String image;
    String date;
    int capacity;
    int categoryId;
    String timeStart;
    String timeEnd;
    String publicType;
    String nameCategory;
   

    EventModel({
        this.id,
        this.title = '',
        this.description= '',
        this.price = 0,
        this.location = '',
        this.image = '',
        this.date= '',
        this.capacity = 0,
        this.categoryId,
        this.timeStart,
        this.timeEnd,
        this.publicType,
        this.nameCategory,

    });

    // factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    //     id: json["id"],
    //     title: json["title"],
    //     description: json["description"],
    //     location: json["location"],
    //     date: json["date"],
    //     price: json["price"],
    //     image: json["image"],
    //     capacity: json["capacity"],
    //     categoryId: json["CategoryId"]
    // );

    EventModel.fromJson(Map<String, dynamic> json)
        : id = json["id"].toString(),
        title = json["title"],
        description = json["description"],
        location = json["location"],
        date = json["date"],
        price = double.parse(json["price"].toString()),
        image = json["image"],
        capacity = json["capacity"],
        categoryId = json["CategoryId"],
        timeStart = json["timeStart"],
        timeEnd = json["timeEnd"],
        publicType = json["publicType"],
        nameCategory = json["Category"]["name"];
        


    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "location": location,
        "image": image,
        "date": date,
        "capacity": capacity,
        "CategoryId": categoryId
    };
}
