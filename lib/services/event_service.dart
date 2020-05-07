import 'dart:convert';

import 'package:event_country/models/evnets_models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


final String _url = 'http://datatecblocks.xyz:4004/graphql';

final _getevent = '{events{id,title,description,price,date,image,location}}'; 
final String img = 'https://static2.bigstockphoto.com/0/9/1/large1500/190827454.jpg';

class EventsServices{
 
  Future<bool> createEevnet(EventModel evnet )async{
    try{
      final url = '$_url?query=mutation{createEvent(title: "${evnet.title}",  description: "${evnet.description}", price: ${evnet.price}, location: "${evnet.location}", image: "$img", date: "${evnet.date}"){ id title description price location image date}}';

      final resp = await http.post(url);
      final decodeData = json.decode(resp.body);
      
        if(resp.statusCode != 200 && resp.statusCode != 201){
          print('algo salio mal');
          return false;
        }
        return true;

       //print(decodeData);
    }catch(e){
      print('este es el error' + e);
    }

   
  }



 Future<List<EventModel>> getEvents()async{
   final url = '$_url?query=$_getevent';
   final resp = await http.get(url);

  final decodedData = json.decode(resp.body);
  print(decodedData);

  return [];
  


 }

}