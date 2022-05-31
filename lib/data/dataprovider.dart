import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:phishing_framework/data/response_parser.dart';
import 'package:phishing_framework/data/models.dart';


class DataProvider {
  ResponseParser parser = ResponseParser();

  static final String kHost = '127.0.0.1:3000';
  //static final String kHost = '192.168.0.199:3000'; //for pc to laptop
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
      "startDate": _formatDate(project.startDate),
      "endDate": _formatDate(project.endDate),
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

  Future<bool> createCampaign(Campaign campaign) async {
    var body = {
      "name": campaign.name,
      "projectId": campaign.projectId,
      "domain": campaign.domain,
      "startDate": _formatDate(campaign.startDate),
      "endDate": _formatDate(campaign.endDate),
      "description": campaign.description
    };

    var jsonBody = jsonEncode(body);
    final response = await http.post(kBaseUrl.replace(path: '/campaigns/create/'), headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Error on creating campaign. Response: ${response.body}');
    }
  }

  Future<List<Project>> getProjects(String email) async {
    final response = await http.get(kBaseUrl.replace(path: '/projects/$email'), headers: headers);

    if (response.statusCode == 200) {
      return parser.parseListOfProjects(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load all projects');
    }
  }

  Future<List<Campaign>> getCampaignsByProjectId(int projectId) async {
    final response = await http.get(kBaseUrl.replace(path: '/campaignsByProjectId/$projectId'), headers: headers);

    if (response.statusCode == 200) {
      return parser.parseListOfCampaigns(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load all campaigns');
    }
  }

  Future<List<Campaign>> getCampaigns() async {
    final response = await http.get(kBaseUrl.replace(path: '/campaigns/all'), headers: headers);

    if (response.statusCode == 200) {
      return parser.parseListOfCampaigns(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load all campaigns');
    }
  }

  ///Standard function to format the date to send a correctly structured date.
  String _formatDate(DateTime? date) {
    String dateString = "${date!.year}-${date.month}-${date.day}";
    return dateString;
  }
}