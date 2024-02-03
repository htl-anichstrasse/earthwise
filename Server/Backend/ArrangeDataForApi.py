import json
import ast
import DbConnector as dbc

# ----- QUIZ -----

# GET QUIZ OVERVIEW - FILTER UND ARRANGE JSON STRING
def get_quiz_overview():
    quiz_data = dbc.get_quiz_overview()
    json_string = {
        "quiz_data": quiz_data
    }
    return json_string
##TODO GEHT

# GET QUIZ BY ID - FILTER AND ARRAGE JSON STRING
def get_quiz_by_id(id):
    quiz_data = dbc.get_quiz_by_id(id)
    row = quiz_data[0]
    quiz_id, name, discription, quiz_type, select_statement = row
    if quiz_type == "mapquiz":
        country_data = dbc.get_countries_by_quiz(select_statement)
        json_string = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "discription": discription,
            "country_data": country_data
        }
        return json_string
    elif quiz_type == "flagquiz":
        country_data = dbc.get_countries_by_quiz(select_statement)
        json_string = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "discription": discription,
            "country_data": country_data
        }
        return json_string
        ##TODO ANDERE FÄLLE WIE FLAGGEN QUIZ MÜSSEN NO GEMACHT WERDEN UND VERNÜFTIGE FEHLERMELDUNG
        ##TODO beziehungsweise isch es wurst i muss lei den typ mit übergeben
    return "quiz type not existing"
##TODO GEHT

# GET ALL QUIZ DATA
def get_all_quiz_data():
    quiz_data = dbc.get_all_quiz_data()
    json_string = []
    for quiz in quiz_data:
        quiz_id, name, discription, quiz_type, select_statement = quiz
        country_data = dbc.get_countries_by_quiz(select_statement)
        quiz_json = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "discription": discription,
            "quiz_type": quiz_type,
            "country_data": country_data
        }
        json_string.append(quiz_json)
    return json_string
##TODO GEHT

# ----- USER -----
##TODO SOWEIT ALLE FUNKTIONEN GESCHRIEBEN UND OPTIMIERT - ABGESCHLOSSEN - FERTIG KOMMENTIERT

# CREATE NEW USER - FILTER AND ARRAGE JSON STRING
def create_new_user(email, username, password):
    #checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success": 
        json_string = {
            "message_type": "Error",
            "message": "A user with this email already exists."
        }
        return json_string
    #creates new user
    return dbc.create_new_user(email, username, password)
#TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# USER LOGIN
def user_login(email, password):
    #checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email,password)
    if login_possible["message_type"] == "Success":
        json_string = {
            "message_type": "Success",
            "message": "User logged in."
        }
        return json_string
    return login_possible
#TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# CHECK IF EMAIL EXISTS
def check_if_email_exists(email):
    #searches all users in the database and checks whether the specified email address exists
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
##TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# CHECK IF USER EXISTS
def check_if_login_is_possible(email, password):
    #checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success": 
        #checks whether the passed password matches the password of the database
        if dbc.get_password_by_email(email) == password:
            json_string = {
                "message_type": "Success",
                "message": ""
            }
        else:
            json_string = {
                "message_type": "Error",
                "message": "Wrong password."
            }
        return json_string
    return email_exists
##TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# CHANGE PASSWORD USER
def change_password_user(email, password, new_password):
    #checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        #changes the password
        dbc.alter_password_user(email, new_password)
        #checks whether the password has been changed
        if dbc.get_password_by_email(email) == new_password:
            json_string = {
                "message_type": "Success",
                "message": "Password changed."
                }  
        else:
            json_string = {
                "message_type": "Error",
                "message": "Password has not been changed. Reason unknown. Please try again."
            }
        return json_string
    return login_possible
##TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# CHANGE USERNAME USER
def change_username_user(email, password, new_username):
    #checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        #changes the username
        dbc.alter_username_user(email, new_username)
        #checks whether the username has been changed
        if dbc.get_username_by_email(email) == new_username:
            json_string = {
                "message_type": "Success",
                "message": "Username changed."
            }
        else:
            json_string = {
                "message_type": "Error",
                "message": "Username has not been changed. Reason unknown. Please try again."
            }
        return json_string
    return login_possible
##TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# DELET USER
def delet_user(email, password):
    #checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        #deletes the user
        dbc.delet_user(email)
        #checks whether the user has been deleted
        email_exists = check_if_email_exists(email)
        if email_exists["message_type"] == "Error":
            json_string = {
                "message_type": "Success",
                "message": "User deleted."
            }
        else:
            json_string = {
                "message_type": "Error",
                "message": "User has not been deletet. Reason unknown. Please try again."
            }
        return json_string 
    return login_possible
##TODO GEHT - FERTIG KOMMENTIERT UND OPTIMIERT - ERNEUTES TESTEN

# ----- SCORE -----

# SET SCORE
def set_score(email, quiz_id, score, achivable_score, needed_time):
    #checks if the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        pass
        ##TODO CHECK IF QUIZ EXISTS
        ##TODO CHECK IF SCORE EXISTS AND IF ITS LOWER
        ##TODO SETSCORE
    pass
    
