class Question {
  final int quizId;
  final String quizName;
  final String description;
  final String quizType;
  final List<List<String>> countryData;

  Question({
    required this.quizId,
    required this.quizName,
    required this.description,
    required this.quizType,
    required this.countryData,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      quizId: json['quiz_id'],
      quizName: json['quiz_name'],
      description: json[
          'description'], // Beachte, dass hier ein Tippfehler im Originaltext vorlag ("discription" statt "description")
      quizType: json['quiz_type'],
      countryData: List<List<String>>.from(
          json['country_data'].map((x) => List<String>.from(x))),
    );
  }
}
