import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)
mycursor = mydb.cursor()

# GET QUIZ OVERVIEW - SELECT
def get_quiz_overview():
    mycursor.execute("select quizId, quizName from quiz")
    return mycursor.fetchall()

# GET QUIZ BY ID - SELECT
def get_quiz_by_id(id):
    mycursor.execute("select * from quiz where quizId = " + str(id))
    return mycursor.fetchall()

def get_countries_by_quiz(needed_properties, criteria, specific_criteria):
    select_statement = "select " + str(needed_properties) + " from country where " + str(criteria) + ' = "' + str(specific_criteria) + '"'
    mycursor.execute(select_statement)
    return mycursor.fetchall()

#TESTEN !!!
# CREATE NEW USER - INSERT
def create_new_user(email, username, password):
    insert_statement = 'insert into user values("' + str(email) + '","' + str(username) + '","' + str(password) + '")'
    mycursor.execute(insert_statement)
    #rückgabe wert sollte boolean sein
    return mycursor.fetchall()

def get_all_users():
    select_statement = "select email from user"
    mycursor.execute(select_statement)
    return mycursor.fetchall()

# USER LOGIN - SELECT
def get_password_by_email(email):
    select_statement = "select password from user where email = " + str(email)
    mycursor.execute(select_statement)
    return mycursor.fetchall()