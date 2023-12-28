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
    mycursor.execute("select quiz_id, name from quiz")
    return mycursor.fetchall()
##TODO GEHT

# GET QUIZ BY ID - SELECT
def get_quiz_by_id(id):
    mycursor.execute("select * from quiz where quiz_id = " + str(id))
    return mycursor.fetchall()
##TODO GEHT

def get_countries_by_quiz(select_statement):
    mycursor.execute(select_statement)
    return mycursor.fetchall()
##TODO GEHT

#TODO TESTEN !!!
# CREATE NEW USER - INSERT
def create_new_user(email, username, password):
    insert_statement = 'insert into user values("' + str(email) + '","' + str(username) + '","' + str(password) + '")'
    mycursor.execute(insert_statement)
    #TODO rückgabe wert sollte boolean sein
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