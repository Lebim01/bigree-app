import 'dart:convert';
import 'package:event_country/models/register_models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


final String _url = 'http://datatecblocks.xyz:4004/graphql';
final _getregister = """{
    ?query=events {
          id,
          title,
          description,
          price,
          date,
          image,
          location
        }
      }
  """; 

class RegisterServices{
 
  Future<bool> createRegister(RegisterModel register) async {
    
    try {
      final mutation = '?query=mutation {register(username : "${register.username}", password: "${register.password}", name: "${register.name}"){id}}';      
      final url = '$_url$mutation';
      final resp = await http.post(url);
      //final decodeData = json.decode(resp.body);

      if(resp.statusCode != 200 && resp.statusCode != 201){
        print('algo salio mal');
        return false;
      }
          
      return true;
    
    } catch(e) {
      print('este es el error' + e);
    }
  }

 Future<List<RegisterModel>> getRegister() async {
    final url = '$_url$_getregister';
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    print("ESTO ES LO QUE IMPRIME" + decodedData);
    return [];
 }
}