from website import Classes as c
from website import DbConnector as dbc 

def get_quiz_overview():
    db_connector = dbc.DatabaseConnector()
    
    # Rufe die Instanzmethode get_quiz_overview auf der erstellten Instanz auf
    quiz_data = db_connector.get_quiz_overview()
    
    quizzes = []
    for i in range(len(quiz_data)):
        id, name = quiz_data[i]
        quiz = c.quiz(id, name, "","","","","")
        print(quiz.quiz_id)
        print(quiz.quiz_name)
        quizzes.append(quiz)
    print(quizzes)
    print(quiz_data)
    return quizzes