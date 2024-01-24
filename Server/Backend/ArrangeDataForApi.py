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
        ##TODO ANDERE FÄLLE WIE FLAGGEN QUIZ MÜSSEN NO GEMACHT WERDEN UND VERNÜFTIGE FEHLERMELDUNG
        ##TODO beziehungsweise isch es wurst i muss lei den typ mit übergeben
    return "quiz type not existing"
##TODO GEHT

# ----- USER -----

# CREATE NEW USER - FILTER AND ARRAGE JSON STRING
def create_new_user(email, username, password):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            json_string = {
                "message_type": "Error",
                "message": "A user with this email already exists."
            }
            return json_string
    return dbc.create_new_user(email, username, password)
#TODO GEHT

# USER LOGIN
def user_login(email, password):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            if dbc.get_password_by_email(email) == password:
                json_string = {
                    "message_type": "Success",
                    "message": "User logged in."
                }
                return json_string
            else:
                print(dbc.get_password_by_email(email))
                json_string = {
                    "message_type": "Error",
                    "message": "Wrong password."
                }
                return json_string   
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
#TODO GEHT

# CHANGE PASSWORD USER
def change_password_user(email, password, new_password):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            if dbc.get_password_by_email(email) == password:
                dbc.alter_password_user(email, new_password)
                if dbc.get_password_by_email(email) == new_password:
                    json_string = {
                    "message_type": "Success",
                    "message": "Password changed."
                    }  
                    return json_string
                else:
                    json_string = {
                        "message_type": "Error",
                        "message": "Password has not been changed. Reason unknown. Please try again."
                    }
                    return json_string
            else:
                json_string = {
                    "message_type": "Error",
                    "message": "Wrong password."
                }
                return json_string   
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
##TODO TESTEN UND EVENTUELL EVIZIENTER GESTALTEN

# CHANGE EMAIL USER
def change_email_user(email, password, new_email):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == new_email:
            json_string = {
                "message_type": "Error",
                "message": "A user with this email already exists."
            }
            return json_string
    for i in allusers:
        if i == email:
            if dbc.get_password_by_email(email) == password:
                dbc.alter_email_user(email, new_email)
                allusers = dbc.get_all_users()
                for y in allusers:
                    if y == new_email:
                        json_string = {
                            "message_type": "Success",
                            "message": "Email changed."
                        }  
                        return json_string
                json_string = {
                    "message_type": "Error",
                    "message": "Email has not been changed. Reason unknown. Please try again."
                }
                return json_string
            else:
                json_string = {
                    "message_type": "Error",
                    "message": "Wrong password."
                }
                return json_string   
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
##TODO TESTEN UND EVENTUELL EVIZIENTER GESTALTEN

# CHANGE USERNAME USER
def change_username_user(email, password, new_username):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            if dbc.get_password_by_email(email) == password:
                dbc.alter_username_user(email, new_username)
                pass
                ##TODO METHODE SCHREIBEN UM DEN NUTZERNAMEN ZU ERHALTEN UND DAMIT ÜBERPRÜFEN OB ER GEÄNDERT WURDE
            else:
                json_string = {
                    "message_type": "Error",
                    "message": "Wrong password."
                }
                return json_string   
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
##TODO METHODE SCHREIBEN UND TESTEN UND EVENTUELL EVIZIENTER GESTALTEN
##TODO NICHT EINFACH UMSETZBAR, DA EMAIL PRIMARY KEY IST


# DELET USER
def delet_user(email, password):
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            if dbc.get_password_by_email(email) == password:
                dbc.delet_user(email)
                allusers = dbc.get_all_users()
                for i in allusers:
                    if i == email:
                        json_string = {
                        "message_type": "Error",
                        "message": "Password has not been changed. Reason unknown. Please try again."
                    }
                    return json_string
                json_string = {
                    "message_type": "Success",
                    "message": "Password changed."
                    }  
                return json_string       
            else:
                json_string = {
                    "message_type": "Error",
                    "message": "Wrong password."
                }
                return json_string   
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string
##TODO TESTEN UND EVENTUELL EVIZIENTER GESTALTEN