import 'package:phishing_framework/data/models.dart';

class ResponseParser {

  //INSERT ID PARSER
  int parseId(Map jsonId) {
    return jsonId['insertId'];
  }

  //USER PARSER
  User parseUser(Map jsonUser) {
    return User(
      id: jsonUser['userId'],
      name: jsonUser['name'],
      email: jsonUser['email'],
    );
  }
}