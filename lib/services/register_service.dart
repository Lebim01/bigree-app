import 'dart:convert';
import 'package:event_country/models/register_models.dart';
import 'package:http/http.dart' as http;

final String _url = 'http://datatecblocks.xyz:4004/graphql';

class RegisterServices{
 
  Future<Object> createRegister(RegisterModel register) async {
    String image = register.image.replaceAll("&", " ");
    
    try {      
      var mutation = '?query=mutation{register(username:"${register.username}",password:"${register.password}",name:"${register.name}",image:"$image",country:"${register.country}",city:"${register.city}"){status,message}}';  
      final url = "$_url$mutation";
      print(url);
      final resp = await http.post(url);
      final decodeData = json.decode(resp.body);

      if(resp.statusCode != 200 && resp.statusCode != 201){
        return { "errors" : [{ "message" : "Ha ocurrido un problema con el servidor" }]};
      }
          
      return json.encode(decodeData);
    
    } catch(e) {
      print('este es el error' + e.toString());
    }
  }
}