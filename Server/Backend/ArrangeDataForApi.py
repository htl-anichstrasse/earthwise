import json
import ast
import DbConnector as dbc

# ----- QUIZ -----
##TODO KOMPLETT ABGESCHLOSSEN

# GET QUIZ OVERVIEW
def get_quiz_overview():
    # gets all ids and names of the quizzes from the database and returns them
    quiz_data = dbc.get_quiz_overview()
    json_string = {
        "quiz_data": quiz_data
    }
    return json_string

# GET QUIZ BY ID
def get_quiz_by_id(id):
    #gets all the data from the quiz with this id
    quiz_data = dbc.get_quiz_by_id(id)
    row = quiz_data[0]
    # filters according to the quiz type and returns corresponding data and returns them
    json_string = filter_quiz(row)
    return json_string

# GET ALL QUIZ DATA
def get_all_quiz_data():
    # gets all data for each quiz from the database
    quiz_data = dbc.get_all_quiz_data()
    json_string = []
    # goes through each quiz individually
    for quiz in quiz_data:
        # filters according to the quiz type and returns corresponding data
        quiz_json = filter_quiz(quiz)
        json_string.append(quiz_json)
    # returns all quiz data
    return json_string

# FILTER QUIZ
def filter_quiz(quiz):
    # splits the quiz into its individual values
    quiz_id, name, description, quiz_type, select_statement = quiz
    # if its a map or a flag quiz the select statement is executed and is returned in a json
    if quiz_type == "mapquiz" or quiz_type == "flagquiz":
        country_data = dbc.get_countries_by_quiz(select_statement)
        country_data_filtered = []
        for country in country_data:
            country_data_filtered.append(country[1])
        quiz_json = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "description": description,
            "quiz_type": quiz_type,
            "country_data": country_data_filtered
        }
    # if it is a table quiz, more values ​​are expected and filtered accordingly
    elif quiz_type == "tablequiz":
        country_data = dbc.get_countries_by_quiz(select_statement)
        country_data_filtered = []
        for country in country_data:
            temp = []
            temp.append(country[1])
            temp.append(country[2])
            country_data_filtered.append(temp)
        quiz_json = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "description": description,
            "quiz_type": quiz_type,
            "country_data": country_data_filtered
        } 
    # if it is a neighboring country quiz, the data is already in the select_statement because it could not be summarized in a select statement
    elif quiz_type == "neighboringcountries":
        quiz_json = {
            "quiz_id": quiz_id,
            "quiz_name": name,
            "description": description,
            "quiz_type": quiz_type,
            "country_data": select_statement
        } 
    # at the end the corresponding json is returned
    return quiz_json

# GET ALL ALTERNATIVE SPELLINGS
def get_all_alternative_spellings():
    # gets all the names and cca2s of the countries from the database
    country_data = dbc.get_countries_by_quiz("select cca2, name from country where independent = true")
    return_value = {}
    # each country is examined individually and checked to see whether alternative spellings exist
    for country in country_data:
        alt_spell = dbc.get_alternative_spellings_to_cca2(country[0])
        if alt_spell != []:
            # if this is the case, they will be added to the return value
            alt_spell_list = [country[1]]
            for i in alt_spell:
                alt_spell_list.append(i[0])
            return_value.update({country[0]: alt_spell_list})
        else:
            # if not, only the name of the country is added
            return_value.update({country[0]: [country[1]]})
    return return_value

# GET ALTERNATIVE SPELLINGS BY CCA2
def get_alternative_spellings_by_cca2(cca2):
    # checks whether this cca2 exists
    cca2_exists = check_if_cca2_exists(cca2)
    if cca2_exists["message_type"] == "Success":
        # if this is the case, the corresponding name is fetched from the database and the corresponding alternative spellings
        country_data = dbc.get_countries_by_quiz("select name from country where independent = true and cca2 = \'" + cca2 + "\'")
        alt_spell = dbc.get_alternative_spellings_to_cca2(cca2)
        # it is then compiled into a return value
        name = country_data[0]
        alt_spell_list = [name[0]]
        if alt_spell != []:
            for i in alt_spell[0]:
                alt_spell_list.append(i)
        return alt_spell_list
    # if cca2 does not exist an error message is returned
    return cca2_exists
            
# CHECH IF CCA2 EXISTS    
def check_if_cca2_exists(cca2):
    # gets all cca2s from the database
    country_data = dbc.get_countries_by_quiz("select cca2 from country where independent = true")
    for i in country_data:
        # go through them all and see if any of them match what was handed over and returns a corresponding message
        if i[0] == cca2:
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    json_string = {
        "message_type": "Error",
        "message": "No existing country with this cca2."
    }
    return json_string

# CHECK IF QUIZ EXISTS
def check_if_quiz_exists(quiz_id):
    # gets all quizzes from the database
    quiz_data = dbc.get_all_quiz_data()
    for quiz in quiz_data:
        # go through them all and see if any of them match what was handed over and returns a corresponding message
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
##TODO KOMPLETT ABGESCHLOSSEN

# CHECK IF SCORE EXISTS
def check_if_score_exists(email, quiz_id):
    # gets all scores from the database
    score_data = dbc.get_all_score_data()
    # goes through each score individually and see if the email and id matches
    for score in score_data:
        if score[0] == email and score[1] == quiz_id:
            # returns a success message if this is the case
            json_string = {
                "message_type": "Success",
                "message": ""
            }
            return json_string
    # returns a error message if this is not the case
    json_string = {
        "message_type": "Error",
        "message": "No existing score with this email and quiz_id."
    }
    return json_string

# SET SCORE
def set_score(email, quiz_id, score, achivable_score, needed_time):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        # checks whether the quiz exists
        quiz_exists = check_if_quiz_exists(quiz_id)
        if quiz_exists["message_type"] == "Success":
            # checks whether a score with this email and this id already exists
            score_exists = check_if_score_exists(email, quiz_id)
            if score_exists["message_type"] == "Success":
                # of this is the case, the score is fetched from the database
                score_db = get_score(email, quiz_id)
                # checks whether the new score is highrt
                if score > score_db[2]:
                    # if this is the case, it will be entered in the database and a corresponding message is returned
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
                # if the new score is not higher, it is checked whether it is identical
                elif score == score_db[2]:
                    # if this is the case, it will be checked whether the new time was faster
                    if needed_time < score_db[4]:
                        # if this is the case, the score is updated and a corresponding message is returned
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
                        # if this is not the case, a corresponding message is returned
                        json_string = {
                            "message_type": "Error",
                            "message": "There is already an entry in the database with a shorter time."
                        }
                        return json_string
                elif score < score_db[2]:
                    # if the new score is lower or the email or quiz does not exist, an error message will also be returned
                    json_string = {
                        "message_type": "Error",
                        "message": "There is already an entry in the database with a higher score."
                    }
                    return json_string
            else:
                # if the score does not yet exist, a new one is created
                create_score = dbc.create_new_score(email, quiz_id, score, achivable_score, needed_time)
                return create_score
        return quiz_exists
    return email_exists

# GET SCORE
def get_score(email, quiz_id):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        # checks whether the quiz exists
        quiz_exists = check_if_quiz_exists(quiz_id)
        if quiz_exists["message_type"] == "Success":
            # checks whether the score exists
            score_exists = check_if_score_exists(email, quiz_id)
            if score_exists["message_type"] == "Success":
                # if so, the score is returned
                score = dbc.get_score(email, quiz_id)
                return score[0]
            # if one of these criteria is not the case, a corresponding error message is returned
            return score_exists
        return quiz_exists
    return email_exists


# GET ALL SCORES BY EMAIL
def get_all_scores_by_email(email):
    # checks whether the email exists
    email_exists = check_if_email_exists(email)
    if email_exists["message_type"] == "Success":
        # if this is the case, all scores will be fetched from the database with this email and returned
        scores = dbc.get_all_scores_by_email(email)
        return scores
    # if the email does not exist, a corresponding error message is returned
    return email_exists