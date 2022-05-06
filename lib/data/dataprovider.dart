import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:phishing_framework/data/response_parser.dart';
import 'package:phishing_framework/data/models.dart';


class DataProvider {
  ResponseParser parser = ResponseParser();

  static final String kHost = '192.168.0.199:3000';
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
    }
  }

  Future<User> login(String email, String password) async {
    var body = {
      "email": email,
      "password": password
    };

    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: '/login/'), headers: headers, body: jsonBody);
    if (response.statusCode == 409) {
      throw Exception('Credentials are not correct!');
    } else if (response.statusCode == 200) {
      try {
        return parser.parseUser(jsonDecode(response.body)[0]);
      } catch (e) {
        throw Exception('Failed to parse user.\nError: $e');
      }
    } else {
      throw Exception('Unknown error occurred during login.');
    }
  }

  Future<bool> createProject(Project project, String email) async {
    var body = {
      "name": project.name,
      "personInCharge": project.personInCharge,
      "domain": project.domain,
      "startDate": project.startDate,
      "endDate": project.endDate,
      "language": project.language,
      "email": email
    };

    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: '/projects/create/'), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Error on creating project. Response: ${response.body}');
    }
  }
}