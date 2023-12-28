import Classes as c
import DbConnector as dbc 

def get_quiz_overview():
    quiz_data = dbc.get_quiz_overview()
    
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