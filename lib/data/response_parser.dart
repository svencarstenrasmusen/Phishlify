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

  //PROJECT PARSER
  Project parseProject(Map jsonProject) {
    return Project(
      id: jsonProject['projectId'],
      userId: jsonProject['userId'],
      name: jsonProject['name'],
      personInCharge: jsonProject['personInCharge'],
      domain: jsonProject['domain'],
      startDate: formatDate(jsonProject['startDate']),
      endDate: formatDate(jsonProject['endDate']),
      language: jsonProject['language']
    );
  }

  List<Project> parseListOfProjects(List jsonList) {
    return jsonList.map((jsonProject) => parseProject(jsonProject)).toList();
  }

  //CAMPAIGN PARSER
  Campaign parseCampaign(Map jsonCampaign) {
    return Campaign(
        id: jsonCampaign['campaignId'],
        projectId: jsonCampaign['projectId'],
        name: jsonCampaign['name'],
        domain: jsonCampaign['domain'],
        startDate: formatDate(jsonCampaign['startDate']),
        endDate: formatDate(jsonCampaign['endDate']),
        description: jsonCampaign['description']
    );
  }

  List<Campaign> parseListOfCampaigns(List jsonList) {
    return jsonList.map((jsonCampaign) => parseCampaign(jsonCampaign)).toList();
  }

  DateTime formatDate(String dateString) {
    return DateTime.parse(dateString);
  }
}