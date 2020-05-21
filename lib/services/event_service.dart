import 'dart:convert';
import 'dart:io';

import 'package:event_country/models/evnets_models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



final String _url = 'http://datatecblocks.xyz:4004/graphql';
final _getevent = '{events(own: true){id title description location date price image capacity CategoryId timeStart timeEnd publicType Category { name } }}'; 
final _event = '{ id price UserEvents { id }}';
final _cancelEvent = '{mutation { cancelEvent(id: 18){ title, status }}}';
final String img = 'https://static2.bigstockphoto.com/0/9/1/large1500/190827454.jpg';

class EventsServices{
 
  Future<bool> createEevnet(EventModel event, String token )async{
    try{
      final url = '$_url?query=mutation{ createEvent( title: "${event.title}", description: "${event.description}", location: "${event.location}", date: "${event.date}", price: ${event.price}, image:"${event.image}", capacity: ${event.capacity}, CategoryId: ${event.categoryId}, timeStart: "${event.timeStart}", timeEnd: "${event.timeEnd}", publicType: "${event.publicType}"){ title, description, location, date, price, image, capacity, CategoryId, timeStart, timeEnd, publicType}}';

      final resp = await http.post(url, headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "JWT $token"
             // HttpHeaders.authorizationHeader: "JWT " + token
        
      });
      final decodeData = json.decode(resp.body);
      print(decodeData);
      
        if(resp.statusCode != 200 && resp.statusCode != 201){
          print('aqui entro');
          return false;
        }
        return true;

       
    }catch(e){
      print('este es el error' + e);
    }

   
  }



   Future<List<EventModel>> getEvents(token) async{
   final url = '$_url?query=$_getevent';
   final resp = await http.get(url, headers: {
     'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "JWT $token"
   });

     final decodedData = await json.decode(resp.body);
     
     final Map<String, dynamic> data = decodedData["data"];
     final List<EventModel> eventos = new List();
    
     
    if(decodedData == null) {
      //return [];
    }else{
        data.forEach((i, even){
     
       //final evenTemp = new EventModel.fromJson(even);
      // //   //  eventos.add(evenTemp);
     
        if(even == null){

        }else{
          final f = even.length;
          //print(even);
           for (var x = 0; x < f; x++) {
             if(even[x] == null){

             }else {
                   final evenTemp = new EventModel.fromJson(even[x]);
                    eventos.add(evenTemp);
             }
          
           }
          
        }
      
        });
    }
    //print('eventso ${eventos[0].timeStart}');
    return eventos;
  
 }

  Future<int> getEvent(token, id ) async{
    final url = '$_url?query={event(id: $id)$_event}';
    final resp = await http.get(url, headers: {
      'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "JWT $token"
    });
    int retu;
    final decodedData = await json.decode(resp.body);
    final Map<String, dynamic> data = decodedData["data"];
      data.forEach((s, data){
        //print(data['price']);
        if(data['UserEvents'].length == 0){
          //print('no tiene usuarios');
          retu = 0;
        } if (data['UserEvents'].length != 0){
            if(data['UserEvents'].length != 0 && data['price'] > 0){
              //print('tiene usuario y un precio');
               retu = 1;
            }else{
               retu = 2;
              //print('solo tiene usuarios');
            }
        } 

        
      });
      //print(retu);
    return retu;
  }
  Future<String> cancelEvent(token, id, motivo) async {
    final url = '$_url?query=mutation { cancelEvent(id: $id, reason: "$motivo"){ title,  status }}';
    final resp = await http.post(url, headers: {
      'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "JWT $token"
    });
    final decodedData = await json.decode(resp.body);
    final data = decodedData["data"];
    final retorno = data["cancelEvent"];
    if(data != null) return 'evento cancelado';
    return retorno;
  }

  Future uploadImageEvent(token, image) async {
    final url = '$_url?query=mutation { uploadPhotoEvent(image: "data:image/jpeg;base64,$image"){message, status}}';
    final resp = await http.post(url, headers: {
      'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "JWT $token"
    });
    final decodedData = await json.decode(resp.body);
    //final data = decodedData["data"];
    //print(decodedData);
  }

}