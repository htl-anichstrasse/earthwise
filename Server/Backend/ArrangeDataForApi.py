import json

import DbConnector as dbc

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
    return "quiz type not existing"
##TODO GEHT

#TODO TESTEN !!!
# CREATE NEW USER - FILTER AND ARRAGE JSON STRING
def create_new_user(user):
    email = user.email
    username =  user.username
    password = user.password
    allusers = dbc.get_all_users()
    if allusers.contains(email):
        json_string = {
            "message_type": "Error",
            "message": "A user with this email already exists."
        }
        return json_string
    if dbc.create_new_user(email, username, password):
        json_string = {
            "message_type": "Success",
            "message": "User created."
        }
        return json_string
    else:
        json_string = {
            "message_type": "Error",
            "message": "Something went wrong try again."
        }
        return json_string

#TODO TESTEN !!!
# USER LOGIN
def user_login(logindata):
    email = logindata.email
    password = logindata.password
    if dbc.get_password_by_email == password:
        json_string = {
            "message_type": "Success",
            "message": "User logged in."
        }
        return json_string
    else:
        json_string = {
            "message_type": "Error",
            "message": "Wrong password"
        }
        return json_string   
    #TODO if für email existiert nicht!