import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:phishing_framework/data/response_parser.dart';
import 'package:phishing_framework/data/models.dart';


class DataProvider {
  ResponseParser parser = ResponseParser();

  static final String kHost = '127.0.0.1:3000';
  static final String kBasePath = '/';
  
  //TODO: change to secure channel HTTPS!
  Uri kBaseUrl = new Uri.http(kHost, kBasePath);

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<int> register(String name, String email, String password) async {
    var body = {
      "name": name,
      "email": email,
      "password": password
    };

    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: '/register/'), headers: headers, body: jsonBody);


    try {
      if (response.body.compareTo('User Already Exists!') == 0) {
        return 0;
      } else {
        parser.parseId(jsonDecode(response.body));
        return 1;
      }
    } catch (e) {
      throw Exception('Failed to register user:\n$e');
      return -1;
    }
  }
}