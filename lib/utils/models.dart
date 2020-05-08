class Event {
  int id;
  String title;
  String description;
  String image;
  double price;
  String location;
  String date;
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
    this.location = event['location'].toString();
    this.date = event['date'].toString();
    this.time = "";
    this.userEvents = event['UserEvents'].toList();
  }
}