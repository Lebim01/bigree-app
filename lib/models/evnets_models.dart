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

    EventModel({
        this.id,
        this.title = '',
        this.description= '',
        this.price = 0.0,
        this.location = '',
        this.image = '',
        this.date= '',
    });

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        location: json["location"],
        image: json["image"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "location": location,
        "image": image,
        "date": date,
    };
}
