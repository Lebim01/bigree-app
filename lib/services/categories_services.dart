import 'dart:convert';

import 'package:event_country/models/categories.models.dart';
import 'package:http/http.dart' as http;

final String _url = 'http://datatecblocks.xyz:4004/graphql';

final _getcategories = '{categories{id,name}}';

class CategoriesServices{



   getCategories() async{
    final url = '$_url?query=$_getcategories';
    final resp = await http.get(url);
    final  decodeData = json.decode(resp.body);
    print(decodeData['data']['categories']);
    return decodeData['data']['categories'];
  }
}