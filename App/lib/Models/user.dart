class User {
  String username;
  String password;
  String mail;
  int score;

  User(
      {required this.username,
      required this.password,
      required this.mail,
      required this.score});

  Map<String, dynamic> toMap() {
    return {
      'mail': mail,
      'password': password,
      'username': username,
      'score': score,
    };
  }
}
