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
        if quiz_type == "mapquiz" or quiz_type == "flagquiz":
            country_data = dbc.get_countries_by_quiz(select_statement)
            country_data_filtered = []
            for country in country_data:
                country_data_filtered.append(country[1])
            quiz_json = {
                "quiz_id": quiz_id,
                "quiz_name": name,
                "discription": discription,
                "quiz_type": quiz_type,
                "country_data": country_data_filtered
            }
        ##TODO SPEZIELLE BEHANDLUNG FÜR TABLEQUIZZES
        ##TODO DA MÜSSEN DIE ANTWORTEN DIREKT MITGESCHICKT WERDEN UND NIT LEI DIE LÄNDERCODES
        json_string.append(quiz_json)
    return json_string
##TODO GEHT

def check_if_quiz_exists(quiz_id):
    quiz_data = dbc.get_all_quiz_data()
    for quiz in quiz_data:
        if quiz_id == quiz[0]:
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    json_string = {
        "message_type": "Error",
        "message": "No existing quiz with this id."
    }
    return json_string

# ----- USER -----
##TODO KOMPLETT ABGESCHLOSSEN

# CREATE NEW USER
def create_new_user(email, username, password):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    # if not, an error message is returned
    if email_exists["message_type"] == "Success": 
        json_string = {
            "message_type": "Error",
            "message": "A user with this email already exists."
        }
        return json_string
    #creates new user and returns a message
    return dbc.create_new_user(email, username, password)

# USER LOGIN
def user_login(email, password):
    # checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email,password)
    # if this is the case, a success message is returned
    if login_possible["message_type"] == "Success":
        json_string = {
            "message_type": "Success",
            "message": "User logged in."
        }
        return json_string
    # if not, an error message is returned
    return login_possible

# CHECK IF EMAIL EXISTS
def check_if_email_exists(email):
    # searches all users in the database and checks whether the specified email address exists
    allusers = dbc.get_all_users()
    for i in allusers:
        if i == email:
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    # if not, an error message is returned
    json_string = {
        "message_type": "Error",
        "message": "No existing user with this email."
    }
    return json_string

# CHECK IF USER EXISTS
def check_if_login_is_possible(email, password):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success": 
        # checks whether the passed password matches the password of the database
        if dbc.get_password_by_email(email) == password:
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": ""
            }
        else:
            # if not, an error message is returned
            json_string = {
                "message_type": "Error",
                "message": "Wrong password."
            }
        return json_string
    # if the email does not exist, an error message is returned
    return email_exists

# CHANGE PASSWORD USER
def change_password_user(email, password, new_password):
    # checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        # changes the password
        dbc.alter_password_user(email, new_password)
        # checks whether the password has been changed
        if dbc.get_password_by_email(email) == new_password:
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": "Password changed."
                }  
        else:
            # if not, an error message is returned
            json_string = {
                "message_type": "Error",
                "message": "Password has not been changed. Reason unknown. Please try again."
            }
        return json_string
    # if the email does not exist or the password is incorrect, an error message is returned
    return login_possible

# CHANGE USERNAME USER
def change_username_user(email, password, new_username):
    # checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        # changes the username
        dbc.alter_username_user(email, new_username)
        # checks whether the username has been changed
        if dbc.get_username_by_email(email) == new_username:
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": "Username changed."
            }
        else:
            # if not, an error message is returned
            json_string = {
                "message_type": "Error",
                "message": "Username has not been changed. Reason unknown. Please try again."
            }
        return json_string
    # if the email does not exist or the password is incorrect, an error message is returned
    return login_possible

# DELETE USER
def delete_user(email, password):
    # checks whether the user exists and the password is correct
    login_possible = check_if_login_is_possible(email, password)
    if login_possible["message_type"] == "Success":
        # deletes the user
        dbc.delete_user(email)
        # checks whether the user has been deleted
        email_exists = check_if_email_exists(email)
        if email_exists["message_type"] == "Error":
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": "User deleted."
            }
        else:
            # if not, an error message is returned
            json_string = {
                "message_type": "Error",
                "message": "User has not been deletet. Reason unknown. Please try again."
            }
        return json_string
    # if the email does not exist or the password is incorrect, an error message is returned
    return login_possible

# GET USERNAME AND LEVEL
def get_username_and_level(email):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        # gets the username and level from the database
        username = dbc.get_username_by_email(email)
        level = dbc.get_level_by_email(email)
        # composes the return value and returns it
        json_string = {
                "username": username,
                "level": level
            }
        return json_string
    # if the email does not exist, an error message is returned
    return email_exists

# GET USERNAME AND LEVEL
def increase_level(email, levelincrease):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        # fetches the previous level from the database
        level = dbc.get_level_by_email(email)
        # calculates the new level
        new_level = levelincrease + level
        # updates the level
        dbc.alter_level_user(email, new_level)
        # checks whether the level has been changed
        if new_level == dbc.get_level_by_email(email):
            # if this is the case, a success message is returned
            json_string = {
                "message_type": "Success",
                "message": "Level increased."
            }
        else:
            # if not, an error message is returned
            json_string = {
                "message_type": "Error",
                "message": "Level has not been increased. Reason unknown. Please try again."
            }
        return json_string
    # if the email does not exist, an error message is returned
    return email_exists

# ----- SCORE -----

# CHECK IF SCORE EXISTS
def check_if_score_exists(email, quiz_id):
    score_data = dbc.get_all_score_data()
    for score in score_data:
        if score[0] == email and score[1] == quiz_id:
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    json_string = {
        "message_type": "Error",
        "message": "No existing score with this email and quiz_id."
    }
    return json_string

# SET SCORE
def set_score(email, quiz_id, score, achivable_score, needed_time):
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        quiz_exists = check_if_quiz_exists(quiz_id)
        if quiz_exists["message_type"] == "Success":
            score_exists = check_if_score_exists(email, quiz_id)
            if score_exists["message_type"] == "Success":
                score_db = get_score(email, quiz_id) #TODO GEHT NO NIT
                if score > score_db[2]:
                    dbc.delete_score(email, quiz_id)
                    deleted_score_exists = check_if_score_exists(email, quiz_id)
                    if deleted_score_exists["message_type"] == "Success":
                        json_string = {
                            "message_type": "Error",
                            "message": "Sccore has not been deletet. Reason unknown. Please try again."
                        }
                        return json_string
                    else:
                        create_score = dbc.create_new_score(email, quiz_id, score, achivable_score, needed_time)
                        json_string = {
                        "message_type": "Success",
                        "message": "The score has been updated."
                        }
                        return json_string
                elif score == score_db[2]:
                    if needed_time < score_db[4]:
                        dbc.delete_score(email, quiz_id)
                        deleted_score_exists = check_if_score_exists(email, quiz_id)
                        if deleted_score_exists["message_type"] == "Success":
                            json_string = {
                                "message_type": "Error",
                                "message": "Sccore has not been deletet. Reason unknown. Please try again."
                            }
                            return json_string
                        else:
                            create_score = dbc.create_new_score(email, quiz_id, score, achivable_score, needed_time)
                            json_string = {
                                "message_type": "Success",
                                "message": "The score has been updated."
                            }
                            return json_string
                    elif needed_time >= score_db[4]:
                        json_string = {
                            "message_type": "Error",
                            "message": "There is already an entry in the database with a shorter time."
                        }
                        return json_string
                elif score < score_db[2]:
                    json_string = {
                        "message_type": "Error",
                        "message": "There is already an entry in the database with a higher score."
                    }
                    return json_string
            else:
                create_score = dbc.create_new_score(email, quiz_id, score, achivable_score, needed_time)
                return create_score
        return quiz_exists
    return email_exists

# GET SCORE
def get_score(email, quiz_id):
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        quiz_exists = check_if_quiz_exists(quiz_id)
        if quiz_exists["message_type"] == "Success":
            score_exists = check_if_score_exists(email, quiz_id)
            if score_exists["message_type"] == "Success":
                score = dbc.get_score(email, quiz_id)
                return score[0]
            return score_exists
        return quiz_exists
    return email_exists


# GET ALL SCORES BY EMAIL
def get_all_scores_by_email(email):
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        scores = dbc.get_all_scores_by_email(email)
        return scores
    return email_exists
