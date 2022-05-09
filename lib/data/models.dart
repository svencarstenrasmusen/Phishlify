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
}