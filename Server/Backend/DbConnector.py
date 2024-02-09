import mysql.connector

# ----- DB -----

def connect_db():
    mydb = mysql.connector.connect(host="localhost", user="root", password="david2003", database="diplomarbeit")
    #mydb = mysql.connector.connect(host="localhost", user="root", password="dipl", database="diplomarbeit")
    return mydb.cursor(), mydb

# ----- QUIZ -----

# GET QUIZ OVERVIEW - SELECT
def get_quiz_overview():
    mycursor, mydb = connect_db()
    mycursor.execute("select quiz_id, name, quiz_type from quiz")
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

# GET QUIZ OVERVIEW - SELECT
def get_all_quiz_data():
    mycursor, mydb = connect_db()
    mycursor.execute("select * from quiz")
    result = mycursor.fetchall()
    mydb.close()
    return result
##TODO GEHT

# ----- USER -----
##TODO KOMPLETT ABGESCHLOSSEN

# CREATE NEW USER - INSERT (to add a user to the database)
def create_new_user(email, username, password):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the insert statement
    insert_query = 'INSERT INTO user VALUES ("' + email + '", "' + username + '", "' + password + '",0)'
    # try executing the insert statement
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        json_string = {
            "message_type": "Success",
            "message": "User created."
        }
    # exception handling
    except mysql.connector.Error as error:
        mydb.rollback()
        json_string = {
            "message_type": "Error",
            "message": error.msg
        }
    # close database connection and return message
    mydb.close()
    return json_string

# GET ALL USERS - SELECT (to get all users stored in the database)
def get_all_users():
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the select statement
    select_statement = "select email from user"
    # executing the select statement
    mycursor.execute(select_statement)
    results = mycursor.fetchall()
    # close database connection
    mydb.close()
    # flattens the multidimensional list into a one-dimensional list and returns this list
    emails = list(sum(results, ()))
    return emails

# GET PASSWORD BY EMAIL - SELECT (to get the password to an email)
def get_password_by_email(email):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the select statement
    select_statement = "select password from user where email = %s"
    # executing the select statement
    mycursor.execute(select_statement, (email,))
    results = mycursor.fetchall()
    # close database connection
    mydb.close()
    # flattens the multidimensional list into a one-dimensional list and returns the first value from it
    passwords = list(sum(results, ()))
    return passwords[0]

# CHANGE PASSWORD USER - ALTER (to change a users password)
def alter_password_user(email, new_password):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the update statement
    update_statement = "update user set password = \'" + new_password + "\' where email = \'" + email + "\'"
    # executing the update statement
    mycursor.execute(update_statement)
    mydb.commit()
    # close database connection
    mydb.close()

# CHANGE USERNAME USER - ALTER (to change a users username)
def alter_username_user(email, new_username):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the update statement
    update_statement = "update user set username = \'" + new_username + "\' where email = \'" + email + "\'"
    # executing the update statement
    mycursor.execute(update_statement)
    mydb.commit()
    # close database connection
    mydb.close()

# GET USERNAME BY EMAIL - SELECT (to get the username to an email)
def get_username_by_email(email):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the select statement
    select_statement = "select username from user where email = %s"
    # executing the select statement
    mycursor.execute(select_statement, (email,))
    results = mycursor.fetchall()
    # close database connection
    mydb.close()
    # flattens the multidimensional list into a one-dimensional list and returns the first value from it
    usernames = list(sum(results, ()))
    return usernames[0]

# DELETE USER - DELET (to delete a user from the database)
def delete_user(email):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the delet statement
    delet_statement = "DELETE FROM user WHERE email = \'" + email + "\'"
    # executing the delet statement
    mycursor.execute(delet_statement)
    mydb.commit()
    # close database connection
    mydb.close()

# GET LEVEL BY EMAIL - SELECT (to get the level to an email)
def get_level_by_email(email):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the select statement
    select_statement = "select level from user where email = %s"
    # executing the select statement
    mycursor.execute(select_statement, (email,))
    results = mycursor.fetchall()
    # close database connection
    mydb.close()
    # flattens the multidimensional list into a one-dimensional list and returns the first value from it
    usernames = list(sum(results, ()))
    return usernames[0]

# CHANGE LEVEL BY EMAIL - ALTER (to change a users level)
def alter_level_user(email, level):
    # establish database connection
    mycursor, mydb = connect_db()
    # assemble the update statement
    update_statement = "update user set level = " + str(level) + " where email = \'" + email + "\'"
    # executing the update statement
    mycursor.execute(update_statement)
    mydb.commit()
    # close database connection
    mydb.close()

# ----- SCORE -----

# GET ALL SCORE DATA - SELECT
def get_all_score_data():
    mycursor, mydb = connect_db()
    mycursor.execute("select * from score")
    result = mycursor.fetchall()
    mydb.close()
    return result

# CREATE NEW SCORE - INSERT
def create_new_score(email, quiz_id, score, achivable_score, needed_time):
    mycursor, mydb = connect_db()
    insert_query = 'INSERT INTO score VALUES ("' + email + '", ' + str(quiz_id) + ', ' + str(score) + ', ' + str(achivable_score) + ', ' + str(needed_time) + ')'
    try:
        mycursor.execute(insert_query)
        mydb.commit()
        json_string = {
            "message_type": "Success",
            "message": "Score created."
        }
    except mysql.connector.Error as error:
        mydb.rollback()
        json_string = {
            "message_type": "Error",
            "message": error.msg
        }
    mydb.close()
    return json_string

# DELETE SCORE - DELET 
def delete_score(email, quiz_id):
    mycursor, mydb = connect_db()
    delet_statement = "DELETE FROM score WHERE email = \'" + email + "\' AND quiz_id = " + str(quiz_id)
    mycursor.execute(delet_statement)
    mydb.commit()
    mydb.close()
    
# GET SCORE - SELECT
def get_score(email, quiz_id):
    mycursor, mydb = connect_db()
    mycursor.execute("select * from score where email = \'" + email + "\' AND quiz_id = " + str(quiz_id))
    result = mycursor.fetchall()
    mydb.close()
    return result

# GET ALL SCORES BY EMAIL - SELECT
def get_all_scores_by_email(email):
    mycursor, mydb = connect_db()
    mycursor.execute("select * from score where email = \'" + email + "\'")
    result = mycursor.fetchall()
    mydb.close()
    return result