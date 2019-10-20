
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {

  NetworkHelper({this.url});
  String url;

  Future getData() async {
    http.Response response = await http.post(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;    
    } else {
      print(response.statusCode);
    }
  }

}