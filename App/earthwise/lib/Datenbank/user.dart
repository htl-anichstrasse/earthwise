class User {
  String username;
  String password;
  String mail;
  int score;

  // Constructor to create a User instance with required fields
  User({
    required this.username,
    required this.password,
    required this.mail,
    required this.score,
  });

  // Converts a User instance into a Map<String, dynamic>, suitable for database operations
  Map<String, dynamic> toMap() {
    return {
      'mail': mail, // User's email address
      'password': password, // User's password
      'username': username, // User's username
      'score': score, // User's score
    };
  }
}
