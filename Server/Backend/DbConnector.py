import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)

mycursor = mydb.cursor()

# GET QUIZ OVERVIEW - SELECTES
def get_quiz_overview():
    mycursor.execute("select quizId, quizName from quiz")
    return mycursor.fetchall()

# GET QUIZ BY ID - SELECTS
def get_quiz_by_id(id):
    mycursor.execute("select * from quiz where quizId = " + str(id))
    return mycursor.fetchall()

def get_countries_by_quiz(needed_properties, criteria, specific_criteria):
    select_statement = "select " + str(needed_properties) + " from country where " + str(criteria) + ' = "' + str(specific_criteria) + '"'
    mycursor.execute(select_statement)
    return mycursor.fetchall()