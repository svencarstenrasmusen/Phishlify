class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  @override
  String toString() {
    return '$name, $email';
  }
}

class Project {
  int? id;
  int? userId;
  String? name;
  String? personInCharge;
  String? domain;
  DateTime? startDate;
  DateTime? endDate;
  String? language;

  Project({this.id, this.userId, this.name, this.personInCharge, this.domain,
    this.startDate, this.endDate, this.language});

  @override
  String toString() {
    return '$id, $name, $domain';
  }

  String formattedStartDate() {
    String dateString = "${startDate!.day}.${startDate!.month}.${startDate!.year}";
    return dateString;
  }

  String formattedEndDate() {
    String dateString = "${endDate!.day}.${endDate!.month}.${endDate!.year}";
    return dateString;
  }
}

class Campaign {
  int? id;
  int? projectId;
  String? name;
  String? domain;
  String? description;
  DateTime? startDate;
  DateTime? endDate;

  Campaign({this.id, this.projectId, this.name, this.domain, this.description, this.startDate, this.endDate});

  @override
  String toString() {
    return 'Campaign: $id, $name, $domain';
  }
}