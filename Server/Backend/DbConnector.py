import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="david2003",
    database="diplomarbeit"
)
mycursor = mydb.cursor()

# ----- QUIZ -----

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

# ----- USER -----

# CREATE NEW USER - INSERT
def create_new_user(email, username, password):
    insert_query = 'INSERT INTO user VALUES ("' + email + '", "' + username + '", "' + password + '")'
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        json_string = {
            "message_type": "Success",
            "message": "User created."
        }
        return json_string
    except mysql.connector.Error as error:
        mydb.rollback()
        json_string = {
            "message_type": "Error",
            "message": error.msg
        }
        return json_string
##TODO GEHT

def get_all_users():
    select_statement = "select email from user"
    mycursor.execute(select_statement)
    results = mycursor.fetchall()
    emails = list(sum(results, ()))
    return emails
##TODO GEHT

# USER LOGIN - SELECT
def get_password_by_email(email):
    select_statement = "select password from user where email = %s"
    mycursor.execute(select_statement, (email,))
    results = mycursor.fetchall()
    passwords = list(sum(results, ()))
    return passwords[0]
##TODO GEHT