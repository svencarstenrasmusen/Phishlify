class User {
  String? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  @override
  String toString() {
    return '$name, $email';
  }
}