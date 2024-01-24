import mysql.connector

# ----- DB -----
def connect_db():
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="david2003",
        database="diplomarbeit"
    )
    return mydb.cursor(), mydb

# ----- QUIZ -----

# GET QUIZ OVERVIEW - SELECT
def get_quiz_overview():
    mycursor, mydb = connect_db()
    mycursor.execute("select quiz_id, name from quiz")
    result = mycursor.fetchall()
    mydb.close()
    return result
##TODO GEHT

# GET QUIZ BY ID - SELECT
def get_quiz_by_id(id):
    mycursor, mydb = connect_db()
    mycursor.execute("select * from quiz where quiz_id = " + str(id))
    result = mycursor.fetchall()
    mydb.close()
    return result
##TODO GEHT

def get_countries_by_quiz(select_statement):
    mycursor, mydb = connect_db()
    mycursor.execute(select_statement)
    result = mycursor.fetchall()
    mydb.close()
    return result
##TODO GEHT

# ----- USER -----

# CREATE NEW USER - INSERT
def create_new_user(email, username, password):
    mycursor, mydb = connect_db()
    insert_query = 'INSERT INTO user VALUES ("' + email + '", "' + username + '", "' + password + '")'
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        json_string = {
            "message_type": "Success",
            "message": "User created."
        }
    except mysql.connector.Error as error:
        mydb.rollback()
        json_string = {
            "message_type": "Error",
            "message": error.msg
        }
    mydb.close()
    return json_string
    
##TODO GEHT

def get_all_users():
    mycursor, mydb = connect_db()
    select_statement = "select email from user"
    mycursor.execute(select_statement)
    results = mycursor.fetchall()
    mydb.close()
    emails = list(sum(results, ()))
    return emails
##TODO GEHT

# USER LOGIN - SELECT
def get_password_by_email(email):
    mycursor, mydb = connect_db()
    select_statement = "select password from user where email = %s"
    mycursor.execute(select_statement, (email,))
    results = mycursor.fetchall()
    mydb.close()
    passwords = list(sum(results, ()))
    return passwords[0]
##TODO GEHT

# CHANGE PASSWORD USER - ALTER
def alter_password_user(email, new_password):
    mycursor, mydb = connect_db()
    update_statement = "update user set password = " + new_password + " where email = " + email
    mycursor.execute(update_statement)
    mydb.commit()
    mydb.close()
##TODO TESTEN

# CHANGE EMAIL USER - ALTER
def alter_email_user(email, new_email):
    pass
##TODO METHODE SCHREIBEN UND TESTEN
##TODO NICHT EINFACH UMSETZBAR, DA EMAIL DER PRIMARY KEY IST

# CHANGE USERNAME USER - ALTER
def alter_username_user(email, new_username):
    mycursor, mydb = connect_db()
    update_statement = "update user set username = " + new_username + " where email = " + email
    mycursor.execute(update_statement)
    mydb.commit()
    mydb.close()
##TODO TESTEN

# DELET USER - DELET
def delet_user(email):
    mycursor, mydb = connect_db()
    delet_statement = "delet from user where email = " + email
    mycursor.execute(delet_statement)
    mydb.commit()
    mydb.close()
##TODO TESTEN