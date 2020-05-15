import 'package:intl/intl.dart';

class Event {
  int id;
  String title;
  String description;
  String image;
  double price;
  int capacity;
  String location;

  String date; 
  String dateFormated;

  String time;
  List userEvents;
  
  /**
   * from graphql
   */
  Event(dynamic event){
    this.id = event['id'].toInt();
    this.title = event['title'].toString();
    this.description = event['description'].toString();
    this.image = event['image'].toString();
    this.price = event['price'].toDouble();
    this.capacity = event['capacity'].toInt();
    this.location = event['location'].toString();
    this.date = event['date'].toString();
    this.dateFormated = DateFormat("dd 'de' MMMM yyyy").format(DateTime.parse(this.date));
    this.time = "";
    this.userEvents = event['UserEvents'].toList();
  }
}